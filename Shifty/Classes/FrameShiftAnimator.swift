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

    //MARK: Initializers
    public required init(source: FrameShiftable, destination: FrameShiftable, deferSnapshotting: Bool = true) {
        
        let initialStates = source.shiftablesForTransitionWith(destination.viewController)
        let finalStates = destination.shiftablesForTransitionWith(source.viewController)
        let finalReference = finalStates.dictionary() { ($0.identifier, $0) }
        
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
    public func performFrameShiftAnimationsIn(_ containerView: UIView, with destinationView: UIView, over duration: TimeInterval?) {
        precondition(Thread.isMainThread, "Frame Shift Animation must be called from the main thread")
        
        frameShifts.forEach { shift in
            
            let initial = shift.initial
            let final = shift.final
            
            //Create a copy of the sourceView according to initialState
            let shiftingView = initial.viewForShiftWithRespectTo(containerView)
            insert(shiftingView, into: containerView, for: shift)
  
            destinationView.layoutIfNeeded()
            
            //If the destination is of the correct type - request a customized animation. If not, then use the default.
            if let destination = self.destination as? CustomFrameShiftable {
                destination.performShiftWith(shiftingView, in: containerView, with: final.snapshot(), duration: duration) {
                    self.performAnimationCleanupFor(shiftingView, shift: shift)
                }
            } else {
                performDefaultShiftAnimationFor(shiftingView, in: containerView, for: shift, over: duration)
            }
        }
        
        print()
    }
}

//MARK: Private Helpers
fileprivate extension FrameShiftAnimator {
    
    func performDefaultShiftAnimationFor(_ shiftingView: UIView, in containerView: UIView, for shift: FrameShift, over duration: TimeInterval?) {
        
        let final = shift.final
        
        //Force the destination to layout - so the position we calculate is up to date (in case it's been invalidated since destinationView laid out).
        final.superview.layoutIfNeeded()
        
        //Animate this shifting view from it's current position to that dictated by finalState
        UIView.animate(withDuration: duration ?? FrameShiftAnimator.defaultAnimationDuration, delay: 0.0, options: [.beginFromCurrentState, .layoutSubviews], animations: {
            
            //the problem is here
            let finalSnapshot = self.destinationSnapshots?[final] ?? final.snapshot()
            finalSnapshot.applyPositionalStateTo(shiftingView, in: containerView)
            
            }, completion: { finished in
                //The shift is complete - remove our animating view and show the originals
                self.performAnimationCleanupFor(shiftingView, shift: shift)
        })
    }
}
