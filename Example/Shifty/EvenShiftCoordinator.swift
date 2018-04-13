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
    
    public func shifts(from sources: [State], to destinations: [State]) -> [Shift] {
        return zip(sources.indices, sources).compactMap { (index, source) in
            guard let match = destinations.first(where: { $0.identifier == source.identifier }) else { return nil }
            
            let timingCurve = index % 2 == 0 ? UICubicTimingParameters(animationCurve: .linear) : UICubicTimingParameters(animationCurve: .easeOut)
            let relativeStart = index % 2 == 0 ? 0 : 0.5
            let relativeEnd = index % 2 == 0 ? 0.5 : 1
            
            let context = CubicAnimationContext(timingParameters: timingCurve, relativeStartTime: relativeStart, relativeEndTime: relativeEnd)
            return Shift(source: source, destination: match, animationContext: context)
        }
    }
}
