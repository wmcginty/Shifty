//
//  DefaultShiftCoordinator.swift
//  Shifty
//
//  Created by William McGinty on 12/28/17.
//

import UIKit

public protocol ShiftCoordinator {
    func shifts(from sources: [Shiftable], to destinations: [Shiftable]) -> [Shift]
}

public struct DefaultShiftCoordinator: ShiftCoordinator {
    
    //MARK: Properties
    public let timingCurve: UITimingCurveProvider
    
    //MARK: Initializers
    public init(timingCurveProvider: UITimingCurveProvider) {
        self.timingCurve = timingCurveProvider
    }
    
    public init(timingCurve: UIViewAnimationCurve = .linear) {
        self.timingCurve = UICubicTimingParameters(animationCurve: timingCurve)
    }

    //MARK: ShiftCoordinator
    public func shifts(from sources: [Shiftable], to destinations: [Shiftable]) -> [Shift] {
        return sources.flatMap { source in
            guard let match = destinations.first(where: { $0.identifier == source.identifier }) else { return nil }
            return Shift(source: source, destination: match, timingCurve: timingCurve)
        }
    }
}
