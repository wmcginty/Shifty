//
//  AnimationParameters.swift
//  Shifty
//
//  Created by William McGinty on 12/29/17.
//

import Foundation

public struct AnimationParameters {
    public let timingCurve: UITimingCurveProvider
    public let relativeStartTime: TimeInterval
    public let relativeEndTime: TimeInterval
    
    // MARK: Initializers
    public init(timingCurve: UITimingCurveProvider, relativeStartTime: TimeInterval = 0.0, relativeEndTime: TimeInterval = 1.0) {
        self.timingCurve = timingCurve
        self.relativeStartTime = relativeStartTime
        self.relativeEndTime = relativeEndTime
    }
}
