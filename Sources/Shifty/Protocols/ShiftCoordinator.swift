//
//  DefaultCoordinator.swift
//  Shifty
//
//  Created by William McGinty on 12/28/17.
//

import UIKit

public protocol ShiftCoordinator {
    
    /// Creates the `Shift` objects that can be animated from the `State` objects found in the source and destination hierarchy.
    ///
    /// - Parameters:
    ///   - sources: The `State` objects residing the source's view hierarchy.
    ///   - destinations: The `State` objects residing the source's view hierarchy.
    /// - Returns: An array of `Shift objects.
    func shifts(from sources: [State], to destinations: [State]) -> [Shift]
}

public struct DefaultCoordinator: ShiftCoordinator {
    
    // MARK: Properties
    public let timingContext: TimingContext
    
    // MARK: Initializers
    public init(animationContext: TimingContext) {
        self.timingContext = animationContext
    }
    
    public init(timingCurve: UIView.AnimationCurve = .easeInOut) {
        self.init(animationContext: CubicAnimationContext(timingParameters: UICubicTimingParameters(animationCurve: timingCurve)))
    }

    // MARK: ShiftCoordinator
    public func shifts(from sources: [State], to destinations: [State]) -> [Shift] {
        return sources.compactMap { source in
            let match = destinations.first { $0 == source }
            return match.map { Shift(source: source, destination: $0, timingContext: timingContext) }
        }
    }
}
