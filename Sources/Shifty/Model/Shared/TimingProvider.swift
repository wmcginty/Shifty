//
//  TimingProvider.swift
//  Shifty-iOS
//
//  Created by William McGinty on 8/31/19.
//  Copyright © 2019 Will McGinty. All rights reserved.
//

import Foundation

// MARK: Subtype
public struct Keyframe {
    public let startTime: Double
    public let endTime: Double
    public var duration: Double { return endTime - startTime }
    
    public init(startTime: Double, endTime: Double) {
        self.startTime = startTime
        self.endTime = endTime
    }
}

public protocol TimingProvider {
    var duration: TimeInterval { get }
    var parameters: UITimingCurveProvider { get }
    var keyframe: Keyframe? { get }
}

public struct SpringTimingProvider: TimingProvider {
    
    // MARK: Properties
    public let duration: TimeInterval
    public let parameters: UITimingCurveProvider
    public var keyframe: Keyframe? { return nil }
    
    // MARK: Initializers
    public init(duration: TimeInterval, dampingRatio: CGFloat = 1.0, initialVelocity: CGVector = .zero) {
        self.duration = duration
        self.parameters = UISpringTimingParameters(dampingRatio: dampingRatio, initialVelocity: initialVelocity)
    }
    
    public init(mass: CGFloat, stiffness: CGFloat, damping: CGFloat, initialVelocity: CGVector) {
        self.duration = 0
        self.parameters = UISpringTimingParameters(mass: mass, stiffness: stiffness, damping: damping, initialVelocity: initialVelocity)
    }
}

public struct CubicTimingProvider: TimingProvider {

    // MARK: Properties
    public let duration: TimeInterval
    public let parameters: UITimingCurveProvider
    public let keyframe: Keyframe?
    
    // MARK: Initializers
    public init(duration: TimeInterval, parameters: UICubicTimingParameters, keyframe: Keyframe? = nil) {
        self.duration = duration
        self.parameters = parameters
        self.keyframe = keyframe
    }
    
    public init(duration: TimeInterval, curve: UIView.AnimationCurve, keyframe: Keyframe? = nil) {
        self.init(duration: duration, parameters: UICubicTimingParameters(animationCurve: curve), keyframe: keyframe)
    }
    
    public init(duration: TimeInterval, controlPoint1: CGPoint, controlPoint2: CGPoint, keyframe: Keyframe? = nil) {
        self.init(duration: duration, parameters: UICubicTimingParameters(controlPoint1: controlPoint1, controlPoint2: controlPoint2), keyframe: keyframe)
    }
}
