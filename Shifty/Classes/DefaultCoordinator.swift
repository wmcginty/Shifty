//
//  DefaultCoordinator.swift
//  Shifty
//
//  Created by William McGinty on 12/28/17.
//

import UIKit

public protocol ShiftCoordinator {
    func shifts(from sources: [State], to destinations: [State]) -> [Shift]
}

public struct DefaultCoordinator: ShiftCoordinator {
    
    // MARK: Properties
    public let animationContext: AnimationContext
    
    // MARK: Initializers
    public init(animationContext: AnimationContext) {
        self.animationContext = animationContext
    }
    
    public init(timingCurve: UIViewAnimationCurve = .easeInOut) {
        self.init(animationContext: CubicAnimationContext(timingParameters: UICubicTimingParameters(animationCurve: timingCurve)))
    }

    // MARK: ShiftCoordinator
    public func shifts(from sources: [State], to destinations: [State]) -> [Shift] {
        return sources.flatMap { source in
            guard let match = destinations.first(where: { $0.identifier == source.identifier }) else { return nil }
            return Shift(source: source, destination: match, animationContext: animationContext)
        }
    }
}
