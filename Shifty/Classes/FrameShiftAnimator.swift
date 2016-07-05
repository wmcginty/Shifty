//
//  FrameShiftAnimator.swift
//  Shifty
//
//  Created by Will McGinty on 4/28/16.
//  Copyright © 2016 will.mcginty. All rights reserved.
//

import UIKit

/// The animator object that handles the coordination of frame shifts from a source to a destination.
public struct FrameShiftAnimator {
    
    /// The source object, conforms to `FrameShiftable`.
    let source: FrameShiftable
    
    /// The destination object, conforms to `FrameShiftable`.
    let destination: FrameShiftable
    
    private let frameShifts: [FrameShift]
    private var destinationSnapshots: [Shiftable: Snapshot]?

    /** 
    Initialize an animator with a pre-determined source and destination.
     
    - parameter source: The source of the shift.
    - parameter destination: The destination of the shift.
    - parameter deferSnapshotting: A boolean value indicating when view snapshotting will take place. A value of true means that the positional state of the view at it's destination will be determined just in time. A value of value means that these state's will be determined at initialization time.
    */
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
    
    /** 
    Perform the frame shifting animation inside the container.
     
    - parameter containerView: The view which contains the transition. This view will be used as the shiftingView's superview.
    - parameter destinationView: The destination view of the transition. This view will be laid out before shifts are completed.
    - parameter duration: An optional duration for the shift. If this value is `nil` the shift will take place over a default duration (0.3s).
    */
    public func performFrameShiftAnimationsIn(_ containerView: UIView, with destinationView: UIView, over duration: TimeInterval?) {
        
        //TODO: Utilize UIViewPropertyAnimator for easy interuptilibity and interaction.
        
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
private extension FrameShiftAnimator {
    
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
