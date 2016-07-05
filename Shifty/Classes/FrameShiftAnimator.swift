//
//  FrameShiftAnimator.swift
//  ShiftKit
//
//  Created by Will McGinty on 4/28/16.
//  Copyright © 2016 will.mcginty. All rights reserved.
//

import UIKit

public struct FrameShiftAnimator {
    
    let source: FrameShiftable
    let destination: FrameShiftable
    
    let frameShifts: [FrameShift]
    var destinationSnapshots: [Shiftable: Snapshot]?
    
    ///Defer snapshotting essentially means when true snapshots will be taken just in time. When false, will be taken at initalization time.
    public init(source: FrameShiftable, destination: FrameShiftable, deferSnapshotting: Bool = true) {
        
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
    
    public func performFrameShiftAnimationsIn(_ containerView: UIView, with destinationView: UIView, over duration: TimeInterval?) {
        
        for shift in frameShifts {
            
            let initial = shift.initial
            let final = shift.final
            
            //Create a copy of the sourceView according to initialState
            let shiftingView = initial.viewForShiftWithRespectTo(containerView)
            
            //To begin the transition, add this shifting view to the container view and hide the source and destination views
            OperationQueue.main().addOperation {
                
                containerView.addSubview(shiftingView)
                initial.view.isHidden = true
                final.view.isHidden = true
                
                //TODO: Add a transitional animation from source/destination view to the shifting view, customizable.
                
                destinationView.layoutIfNeeded()
                
                //If the destination is of the correct type - it will create a customized animation. If not, then use the default.
                if let destination = self.destination as? CustomFrameShiftable {
                    destination.performShiftWith(shiftingView, in: containerView, with: final.snapshot(), duration: duration) {
                        self.performAnimationCleanupFor(shiftingView, shift: shift)
                    }
                } else {
                    self.performDefaultShiftAnimationFor(shiftingView, in: containerView, for: shift, over: duration)
                }
            }
        }
    }
}

//MARK: Private Helpers
extension FrameShiftAnimator {
    
    private func performDefaultShiftAnimationFor(_ shiftingView: UIView, in containerView: UIView, for shift: FrameShift, over duration: TimeInterval?) {
        
        let final = shift.final
        
        //Force the destination to layout - so the position we calculate is up to date.
        final.superview.layoutIfNeeded()
        
        //Animate this shifting view from it's current position to that dictated by finalState
        UIView.animate(withDuration: duration ?? 0.3, delay: 0.0, options: [.beginFromCurrentState, .layoutSubviews], animations: {
            
            //the problem is here
            let finalSnapshot = self.destinationSnapshots?[final] ?? final.snapshot()
            finalSnapshot.applyPositionalStateTo(shiftingView, in: containerView)
            
            }, completion: { finished in
                //The shift is complete - remove our animating view and show the originals
                self.performAnimationCleanupFor(shiftingView, shift: shift)
        })
    }
    
    private func performAnimationCleanupFor(_ shiftingView: UIView, shift: FrameShift) {
        shift.initial.view.isHidden = false
        shift.final.view.isHidden = false
        shiftingView.removeFromSuperview()
    }
    
    private func configuredSnapshotsFor(_ states: [Shiftable]) -> [Shiftable: Snapshot] {
        return states.dictionary(){ ($0, $0.snapshot()) }
    }
}
