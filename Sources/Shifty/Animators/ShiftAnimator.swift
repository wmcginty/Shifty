//
//  ShiftAnimator.swift
//  Shifty
//
//  Created by William McGinty on 8/31/19.
//  Copyright © 2019 Will McGinty. All rights reserved.
//

import UIKit

/// The `ShiftAnimator` is capable of creating, configuring an animating a replicant for a `Shift` animation from its source to its destination. The `Shift` animation
/// will be cleaned up on completion of the animation to the `Shift`s destination.
open class ShiftAnimator: NSObject {
    
    // MARK: - Subtypes
    public enum CleanupStrategy {
        /// After the shift animations have completed, the animator will automatically clean up any replicants
        case automatic
        
        /// The replicants will remain in place after the animations have completed, until `cleanupAfter` has been called
        case manual
        
        fileprivate func automaticCleanupActions(for replicant: UIView, shift: Shift) {
            switch self {
            case .automatic: shift.cleanup(replicant: replicant)
            case .manual: break
            }
        }
    }
    
    // MARK: - Properties
    public let timingProvider: TimingProvider
    public let shiftAnimator: UIViewPropertyAnimator
    
    public var cleanupStrategy: CleanupStrategy = .automatic
    
    private var destinations: [Shift: Snapshot] = [:]
    private var configuredReplicants: [Shift: UIView] = [:]

    // MARK: - Initializers
    public init(timingProvider: TimingProvider) {
        self.timingProvider = timingProvider
        self.shiftAnimator = UIViewPropertyAnimator(duration: timingProvider.duration, timingParameters: timingProvider.parameters)
    }
 
    // MARK: - Interface
    open func commit(_ shifts: [Shift]) {
        shifts.forEach { destinations[$0] = $0.destinationSnapshot() }
    }
    
    open func configureShiftAnimations(for shifts: [Shift], in container: UIView,
                                       with insertionStrategy: Shift.Target.ReplicantInsertionStrategy = .standard, completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        shifts.forEach { shift in
            let destination = destinations[shift]
            let replicant = shift.configuredReplicant(in: container, with: insertionStrategy)
            configuredReplicants[shift] = replicant
            shift.layoutDestinationIfNeeded()
            
            //For certain positional animations, a brief configuration period is required pre-animation
            shift.preshift(for: replicant, using: destination)
            
            shiftAnimator.addAnimations { [weak self] in
                self?.animations(for: shift, with: replicant, using: destination)
            }
            
            shiftAnimator.addCompletion { [weak self] _ in
                self?.cleanupStrategy.automaticCleanupActions(for: replicant, shift: shift)
            }
        }
        
        completion.map(shiftAnimator.addCompletion)
    }
        
    open func animate(_ shifts: [Shift], in container: UIView,
                      with insertionStrategy: Shift.Target.ReplicantInsertionStrategy = .standard, completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        configureShiftAnimations(for: shifts, in: container, with: insertionStrategy, completion: completion)
        startAnimation()
    }
    
    open func cleanupAfter(shifts: [Shift]) {
        shifts.forEach { shift in
            configuredReplicants[shift].map(shift.cleanup(replicant:))
        }
    }
}

// MARK: - Helper
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
