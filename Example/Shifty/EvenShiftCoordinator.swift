//
//  EvenShiftCoordinator.swift
//  Shifty_Example
//
//  Created by William McGinty on 12/28/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Shifty

struct EvenShiftCoordinator: ShiftCoordinator {
    
    public func shifts(from sources: [Shiftable], to destinations: [Shiftable]) -> [Shift] {
        return zip(sources.indices, sources).flatMap { (index, source) in
            guard let match = destinations.first(where: { $0.identifier == source.identifier }) else { return nil }
            let timingCurve = index % 2 == 0 ? UICubicTimingParameters(animationCurve: .easeIn) : UICubicTimingParameters(animationCurve: .easeOut)
            return Shift(source: source, destination: match, timingCurve: timingCurve)
        }
    }
}
