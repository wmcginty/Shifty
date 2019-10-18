//
//  ShiftAnimator.swift
//  Shifty
//
//  Created by William McGinty on 8/31/19.
//  Copyright © 2019 Will McGinty. All rights reserved.
//

import Foundation

/// The `ShiftAnimator` is capable of creating, configuring an animating a replicant for a `Shift` animation from its source to its destination. The `Shift` animation
/// will be cleaned up on completion of the animation to the `Shift`s destination.
open class ShiftAnimator: NSObject {
    
    // MARK: Properties
    public let timingProvider: TimingProvider
    public let shiftAnimator: UIViewPropertyAnimator
    
    public private(set) var destinations: [Shift: Snapshot] = [:]

    // MARK: Initializers
    public init(timingProvider: TimingProvider) {
        self.timingProvider = timingProvider
        self.shiftAnimator = UIViewPropertyAnimator(duration: timingProvider.duration, timingParameters: timingProvider.parameters)
    }
 
    // MARK: Interface
    open func commit(_ shifts: [Shift]) {
        shifts.forEach { destinations[$0] = $0.destinationSnapshot() }
    }
    
    open func configureShiftAnimations(for shifts: [Shift], in container: UIView,
                                       with insertionStrategy: Shift.Target.ReplicantInsertionStrategy = .standard, completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        shifts.forEach { shift in
            let destination = destinations[shift]
            let replicant = shift.configuredReplicant(in: container, with: insertionStrategy)
            shift.layoutDestinationIfNeeded()
            
            //For certain positional animations, a brief configuration period is required pre-animation
            shift.preshift(for: replicant, using: destination)
            
            shiftAnimator.addAnimations { [weak self] in
                self?.animations(for: shift, with: replicant, using: destination)
            }

            shiftAnimator.addCompletion { _ in
                shift.cleanup(replicant: replicant)
            }
        }
        
        completion.map(shiftAnimator.addCompletion)
    }
        
    open func animate(_ shifts: [Shift], in container: UIView,
                      with insertionStrategy: Shift.Target.ReplicantInsertionStrategy = .standard, completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        configureShiftAnimations(for: shifts, in: container, with: insertionStrategy, completion: completion)
        startAnimation()
    }
}

// MARK: Helper
extension ShiftAnimator {
    
    func animations(for shift: Shift, with replicant: UIView, using destination: Snapshot?) {
        guard let keyframe = timingProvider.keyframe else {
            return shift.shift(for: replicant, using: destination)
        }
        
        UIView.animateKeyframes(withDuration: 0.0, delay: 0.0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: keyframe.startTime, relativeDuration: keyframe.duration) {
                shift.shift(for: replicant, using: destination)
            }
        }, completion: nil)
    }
}
