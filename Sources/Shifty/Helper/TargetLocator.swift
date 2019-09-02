//
//  TargetLocator.swift
//  Shifty-iOS
//
//  Created by William McGinty on 8/31/19.
//  Copyright © 2019 Will McGinty. All rights reserved.
//

import Foundation

protocol TargetLocator {
    
    /// Searches the view hierarchy of a given source and destination to find possible `Shift.Target` objects.
    ///
    /// - Parameters:
    ///   - source: The source content view whose subview will be searched for `Target`s.
    ///   - destination: The destination content view whose subview will be searched for `Target`s.
    /// - Returns: A tuple of possible `Shift.Target` objects who can be matched with a corresponding target in the destination.
    func locatedTargetsForShift(from source: ShiftTransitionable, to destination: ShiftTransitionable) -> (sources: [Shift.Target], destinations: [Shift.Target])
}

struct DefaultTargetLocator: TargetLocator {

    // MARK: Interface
    func locatedTargetsForShift(from source: ShiftTransitionable, to destination: ShiftTransitionable) -> (sources: [Shift.Target], destinations: [Shift.Target]) {
        guard source.isShiftingEnabled && destination.isShiftingEnabled else { return (sources: [], destinations: []) }
        
        let sourceViews = flattenedHierarchy(for: source.contentView, withExclusions: source.shiftExclusions)
        let destinationViews = flattenedHierarchy(for: destination.contentView, withExclusions: destination.shiftExclusions)
        return (sources: sourceViews.compactMap { $0.shiftTarget }, destinations: destinationViews.compactMap { $0.shiftTarget })
    }
}

// MARK: Helper
private extension TargetLocator {

    func flattenedHierarchy(for view: UIView, withExclusions exclusions: [UIView]) -> [UIView] {
        guard !exclusions.contains(view), !view.isHidden else { return [] }
        return [view] + view.subviews.flatMap { flattenedHierarchy(for: $0, withExclusions: exclusions) }
    }
}
