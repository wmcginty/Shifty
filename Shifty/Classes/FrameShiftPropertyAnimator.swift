//
//  FrameShiftPropertyAnimator.swift
//  Pods
//
//  Created by William McGinty on 7/6/16.
//
//

import Foundation

@available(iOS 10.0, *)
public class FrameShiftPropertyAnimator: FrameShiftAnimatorType {
    
    //MARK: Public Properties
    public let source: FrameShiftable
    public let destination: FrameShiftable
    
    public fileprivate(set)var propertyAnimator: UIViewPropertyAnimator?
    
    //MARK: Private Properties
    fileprivate let frameShifts: [FrameShift]
    fileprivate var destinationSnapshots: [Shiftable: Snapshot]?
    
    //MARK: Initializers
    public required init(source: FrameShiftable, destination: FrameShiftable, deferSnapshotting: Bool = true) {
        
        let initialStates = source.shiftablesForTransition(with: destination.viewController)
        let finalStates = destination.shiftablesForTransition(with: source.viewController)
        let finalReference = finalStates.toDictionary { ($0.identifier, $0) }
        
        self.source = source
        self.destination = destination
        self.frameShifts = initialStates.flatMap() {
            guard let finalState = finalReference[$0.identifier] else { return nil }
            return FrameShift(initialState: $0, finalState: finalState)
        }
        
        if !deferSnapshotting {
            destinationSnapshots = configuredSnapshotsFor(finalStates)
        }
    }
    
    public func performFrameShiftAnimations(in containerView: UIView, with destinationView: UIView, over duration: TimeInterval?) {
        precondition(Thread.isMainThread, "Frame Shift Animation must be called from the main thread")
    
        frameShifts.forEach { shift in
            
            let initial = shift.initial
            let final = shift.final
            
            //Create a copy of the sourceView according to initialState
            let shiftingView = initial.viewForShiftWithRespect(to: containerView)
            insert(shiftingView, into: containerView, for: shift)
            
            destinationView.layoutIfNeeded()
            
            //If the destination is of the correct type - request a customized animation. If not, then use the default.
            if let destination = self.destination as? CustomFrameShiftable {
                destination.performShift(with: shiftingView, in: containerView, with: final.snapshot(), duration: duration) {
                    self.performAnimationCleanup(for: shiftingView, shift: shift)
                }
            } else {
                performDefaultShiftAnimationFor(shiftingView, in: containerView, for: shift, over: duration)
            }
        }
    }
}

//MARK: Private Helpers
@available(iOS 10.0, *)
fileprivate extension FrameShiftPropertyAnimator {
    
    func defaultShiftAnimationBlockFor(_ shiftingView: UIView, in containerView: UIView, for shift: FrameShift, over duration: TimeInterval?) -> () -> Void {
        //Force the destination to layout - so the position we calculate is up to date.
        shift.final.superview.layoutIfNeeded()
        
        let finalSnapshot = destinationSnapshots?[shift.final] ?? shift.final.snapshot()
        return {
            //Apply the final positional state to the shifting view
            finalSnapshot.applyPositionalState(to: shiftingView, in: containerView)
        }
    }
    
    func performDefaultShiftAnimationFor(_ shiftingView: UIView, in containerView: UIView, for shift: FrameShift, over duration: TimeInterval?) {
        
        let final = shift.final
        
        //Force the destination to layout - so the position we calculate is up to date.
        final.superview.layoutIfNeeded()
        
        let animator = currentDefaultPropertyAnimatorFor(duration)
        animator.addAnimations(defaultShiftAnimationBlockFor(shiftingView, in: containerView, for: shift, over: duration))
        animator.addCompletion { [unowned self] in self.defaultShiftAnimationCleanupFor($0, shiftingView: shiftingView, shift: shift) }
    }
    
    func defaultShiftAnimationCleanupFor(_ finalState: UIViewAnimatingPosition, shiftingView: UIView, shift: FrameShift) {
        switch finalState {
        case .start: performAnimationCleanup(for: shiftingView, shift: shift)
        case .current: assert(false, "WIP")
        case .end: performAnimationCleanup(for: shiftingView, shift: shift)
        }
    }
    
    func currentDefaultPropertyAnimatorFor(_ duration: TimeInterval?) -> UIViewPropertyAnimator {
        if let animator = propertyAnimator {
            return animator
        } else {
            let animator = UIViewPropertyAnimator(duration: duration ?? FrameShiftPropertyAnimator.defaultAnimationDuration, curve: .easeInOut, animations: nil)
            propertyAnimator = animator
            
            return animator
        }
    }
}
