//
//  FrameShiftPropertyAnimator.swift
//  Shifty
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
    
    public func performFrameShiftAnimations(in containerView: UIView, with destinationView: UIView, over duration: TimeInterval?, completion: FrameShiftAnimationCompletion? = nil) {
        assert(Thread.isMainThread, "Frame Shift Animation must be called from the main thread")
    
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
    
    func defaultShift(for shiftingView: UIView, in containerView: UIView, for shift: FrameShift, over duration: TimeInterval?) -> () -> Void {
        
        return {
            let finalSnapshot = self.destinationSnapshots?[shift.final] ?? shift.final.snapshot()
            finalSnapshot.applyPositionalState(to: shiftingView, in: containerView)
        }
    }
    
    func performDefaultShiftAnimationFor(_ shiftingView: UIView, in containerView: UIView, for shift: FrameShift, over duration: TimeInterval?) {
        
        let final = shift.final
        
        //Force the destination to layout - so the position we calculate is up to date.
        final.superview.layoutIfNeeded()
        
        let animator = currentDefaultPropertyAnimatorFor(duration)
        animator.addAnimations(defaultShift(for: shiftingView, in: containerView, for: shift, over: duration))
        animator.addCompletion { [unowned self] in self.defaultShiftAnimationCleanupFor($0, shiftingView: shiftingView, shift: shift) }
    }
    
    func defaultShiftAnimationCleanupFor(_ finalState: UIViewAnimatingPosition, shiftingView: UIView, shift: FrameShift) {
        switch finalState {
        case .start: performAnimationCleanup(for: shiftingView, shift: shift)
        case .current: fatalError("NYI")
        case .end: performAnimationCleanup(for: shiftingView, shift: shift)
        }
    }
    
    func currentDefaultPropertyAnimatorFor(_ duration: TimeInterval?) -> UIViewPropertyAnimator {
        if propertyAnimator == nil {
            let animator = UIViewPropertyAnimator(duration: duration ?? FrameShiftPropertyAnimator.defaultAnimationDuration, curve: .easeInOut, animations: nil)
            propertyAnimator = animator
        }
        
        assert(propertyAnimator != nil)
        return propertyAnimator!
    }
}
