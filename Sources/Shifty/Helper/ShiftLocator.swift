//
//  ShiftCoordinator.swift
//  Shifty-iOS
//
//  Created by William McGinty on 12/28/17.
//

import UIKit

public protocol ShiftLocator {
    
    /// Creates the `Shift` objects that can be animated from the given `Target` objects.
    ///
    /// - Parameters:
    ///   - sources: The `Target` objects residing the source's view hierarchy.
    ///   - destinations: The `Target` objects residing the source's view hierarchy.
    /// - Returns: An array of `Shift objects suitable for animation.
    func shifts(from sources: [Shift.Target], to destinations: [Shift.Target]) -> [Shift]
}

public extension ShiftLocator {
    
    /// Creates the `Shift` objects that can be animated from the `Target` objects found in the `source` and `destination`..
    ///
    /// - Parameters:
    ///   - source: The source of the shift transition.
    ///   - destination: The destination of the shift transition
    ///   - targetLocator: The object used to locate the viable `Shift.Target` objects inside `source and `destination`.
    /// - Returns: An array of `Shift objects suitable for animation.
    func shifts(from source: ShiftTransitionable, to destination: ShiftTransitionable, using targetLocator: TargetLocator) -> [Shift] {
        let result = targetLocator.locatedTargetsForShift(from: source, to: destination)
        return shifts(from: result.sources, to: result.destinations)
    }
}

public struct DefaultShiftLocator: ShiftLocator {
    
    // MARK: Properties
    public let timingProvider: TimingProvider
    
    // MARK: Initializers
    public init(timingProvider: TimingProvider) {
        self.timingProvider = timingProvider
    }

    // MARK: ShiftCoordinator
    public func shifts(from sources: [Shift.Target], to destinations: [Shift.Target]) -> [Shift] {
        var modifiableDestinations = destinations
        return sources.compactMap { source in
            let match = modifiableDestinations.removeFirst(matching: source)
            return match.map { Shift(source: source, destination: $0) }
        }
    }
}

// MARK: Helper
private extension Array where Element: Equatable {
    
    mutating func removeFirst(matching element: Element) -> Element? {
        return removeFirst(where: { element == $0 })
    }
    
    mutating func removeFirst(where transform: (Element) throws -> Bool) rethrows -> Element? {
        let element = try first(where: transform)
        if let index = element.flatMap(firstIndex) {
            remove(at: index)
        }
        
        return element
    }
}
