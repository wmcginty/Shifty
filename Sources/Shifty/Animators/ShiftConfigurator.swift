//
//  ShiftConfigurator.swift
//  Shifty-iOS
//
//  Created by William McGinty on 10/6/19.
//  Copyright © 2019 Will McGinty. All rights reserved.
//

import Foundation

/// The `ShiftConfigurator` class is responsible for configuring the replicant that performs each `Shift` animation,
/// though it does not perform any animation itself. This class can be useful for when you want to perform a `Shift` transition
/// where none of the components move. This is preferable to using the `ShiftAnimator` as Core Animation will not generate any animations in this scenario.
open class ShiftConfigurator {
    
    // MARK: Properties
    private var configuredReplicants: [Shift: UIView] = [:]
    
    // MARK: Initializers
    public init() { /* No op */ }
    
    // MARK: Interface
    open func configureShifts(_ shifts: [Shift], in container: UIView,
                              with insertionStrategy: Shift.Target.ReplicantInsertionStrategy = .standard) {
        shifts.forEach { shift in
            let replicant = shift.configuredReplicant(in: container, with: insertionStrategy)
            configuredReplicants[shift] = replicant
            
            shift.layoutDestinationIfNeeded()
        }
    }
    
    open func cleanupShifts(_ shifts: [Shift]) {
        shifts.forEach { shift in
            configuredReplicants[shift].map { shift.cleanup(replicant: $0) }
        }
    }
}
