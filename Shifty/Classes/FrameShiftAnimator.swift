//
//  FrameShiftAnimator.swift
//  Shifty
//
//  Created by Will McGinty on 4/28/16.
//  Copyright © 2016 will.mcginty. All rights reserved.
//

import UIKit

/// The animator object that handles the coordination of frame shifts from a source to a destination.
public class FrameShiftAnimator: FrameShiftAnimatorType {
    
    //MARK: Public Properties
    public let source: FrameShiftable
    public let destination: FrameShiftable
    
    //MARK: Private Properties
    fileprivate let frameShifts: [FrameShift]
    fileprivate var destinationSnapshots: [Shiftable: Snapshot]?
    
    fileprivate var shiftAnimations: (() -> Void)?
    fileprivate var shiftCompletions: (() -> Void)?

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
    
    //MARK: FrameShiftAnimatorType
    public func performFrameShiftAnimations(in containerView: UIView, with destinationView: UIView, over duration: TimeInterval?, completion: FrameShiftAnimationCompletion? = nil) {
        assert(Thread.isMainThread, "Frame Shift Animation must be called from the main thread")
        
        //Force layout pass on destinationView so final shift positions are accurate
        destinationView.layoutIfNeeded()
        
        //Configure our individual animation and completion blocks and compose them together
        frameShifts.forEach { shift in
            
            let initial = shift.initial
            
            //Create a copy of the sourceView according to initialState
            let shiftingView = initial.viewForShiftWithRespect(to: containerView)
            insert(shiftingView, into: containerView, for: shift)

            let singleShift = defaultShift(for: shiftingView, in: containerView, for: shift)
            addAnimations(singleShift)
            
            let singleCompletion = { self.performAnimationCleanup(for: shiftingView, shift: shift) }
            addCompletion(singleCompletion)
        }
        
        UIView.animate(withDuration: duration ?? FrameShiftAnimator.defaultAnimationDuration, delay: 0.0, options: [.beginFromCurrentState], animations: {
            
            //Perform the individual animations in a single animation block
            self.shiftAnimations?()

            }) { finished in
                
                //Perform cleanup for each shift, and then overall
                self.shiftCompletions?()
                completion?()
        }
    }
}

//MARK: Animation and Completion
fileprivate extension FrameShiftAnimator {
    func addAnimations(_ animations: @escaping () -> Void) {
        let currentAnimations = shiftAnimations
        
        shiftAnimations = {
            currentAnimations?()
            animations()
        }
    }
    
    func addCompletion(_ completion: @escaping () -> Void) {
        let currentCompletion = shiftCompletions
        
        shiftCompletions = {
            currentCompletion?()
            completion()
        }
    }
}

//MARK: Private Helpers
fileprivate extension FrameShiftAnimator {
    
    func defaultShift(for shiftingView: UIView, in containerView: UIView, for shift: FrameShift) -> () -> Void  {
        
        return {
            let finalSnapshot = self.destinationSnapshots?[shift.final] ?? shift.final.snapshot()
            finalSnapshot.applyPositionalState(to: shiftingView, in: containerView)
        }
    }
}
