//
//  ShiftAnimator+Convenience.swift
//  Shifty-iOS
//
//  Created by William McGinty on 9/4/19.
//  Copyright © 2019 Will McGinty. All rights reserved.
//

import Foundation

public extension ShiftAnimator {
    
    func configureShiftAnimations(from source: ShiftTransitionable, to destination: ShiftTransitionable, in container: UIView,
                                  with insertionStrategy: Shift.Target.ReplicantInsertionStrategy = .standard, completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        let locator = ShiftLocator()
        configureShiftAnimations(for: locator.shifts(from: source, to: destination), in: container, with: insertionStrategy, completion: completion)
    }
    
    func animateShifts(from source: ShiftTransitionable, to destination: ShiftTransitionable, in container: UIView,
                       with insertionStrategy: Shift.Target.ReplicantInsertionStrategy = .standard, completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        let locator = ShiftLocator()
        animate(locator.shifts(from: source, to: destination), in: container, with: insertionStrategy, completion: completion)
    }
}
