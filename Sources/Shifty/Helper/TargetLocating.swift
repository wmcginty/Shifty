//
//  TargetLocating.swift
//  Shifty-iOS
//
//  Created by William McGinty on 8/31/19.
//  Copyright © 2019 Will McGinty. All rights reserved.
//

import UIKit

public protocol TargetLocating {
    
    /// Searches the view hierarchy of a given source and destination to find possible `Shift.Target` objects.
    ///
    /// - Parameters:
    ///   - source: The source content view whose subview will be searched for `Target`s.
    ///   - destination: The destination content view whose subview will be searched for `Target`s.
    /// - Returns: A tuple of possible `Shift.Target` objects who can be matched with a corresponding target in the destination.
    func locatedTargetsForShift(from source: ShiftTransitioning, to destination: ShiftTransitioning) -> (sources: [Shift.Target], destinations: [Shift.Target])
}

public struct TargetLocator: TargetLocating {
    
    // MARK: - Initializer
    public init() { /* No op */ }

    // MARK: - Interface
    public func locatedTargetsForShift(from source: ShiftTransitioning, to destination: ShiftTransitioning) -> (sources: [Shift.Target], destinations: [Shift.Target]) {
        guard source.isShiftingEnabled && destination.isShiftingEnabled else { return (sources: [], destinations: []) }
        
        let sourceViews = source.contentView.flattenedHierarchy(withExclusions: source.shiftExclusions, excluder: source.shiftExcluder)
        let destinationViews = destination.contentView.flattenedHierarchy(withExclusions: destination.shiftExclusions, excluder: destination.shiftExcluder)
        return (sources: sourceViews.compactMap { $0.shiftTarget }, destinations: destinationViews.compactMap { $0.shiftTarget })
    }
}
