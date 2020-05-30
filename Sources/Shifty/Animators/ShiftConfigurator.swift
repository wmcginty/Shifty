//
//  ShiftConfigurator.swift
//  Shifty-iOS
//
//  Created by William McGinty on 10/6/19.
//  Copyright © 2019 Will McGinty. All rights reserved.
//

import Foundation

/// The `ShiftConfigurator` is capable of creating and configuring a replicant for a `Shift` animation, but is not capable of performing the animation itself.
/// This can be useful when the `Shift` being performed is stationary, or would otherwise not generate a Core Animation object. Instead of relying on the automatic completion
/// of the animation, this configured replicant will remain stationary until manually cleaned up.
open class ShiftConfigurator {
    
    // MARK: - Properties
    private var configuredReplicants: [Shift: UIView] = [:]
    
    // MARK: - Initializers
    public init() { /* No op */ }
    
    // MARK: - Interface
    open func configureShifts(_ shifts: [Shift], in container: UIView,
                              with insertionStrategy: Shift.Target.ReplicantInsertionStrategy = .standard) {
        shifts.forEach { shift in
            let replicant = shift.configuredReplicant(in: container, with: insertionStrategy)
            configuredReplicants[shift] = replicant
            
            shift.layoutDestinationIfNeeded()
        }
    }
    
    open func cleanupAfter(shifts: [Shift]) {
        shifts.forEach { shift in
            configuredReplicants[shift].map { shift.cleanup(replicant: $0) }
        }
    }
}
