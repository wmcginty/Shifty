//
//  TimingProvider.swift
//  Shifty-iOS
//
//  Created by William McGinty on 8/31/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

public protocol TimingProvider {
    var duration: TimeInterval { get }
    var parameters: UITimingCurveProvider { get }
}

public struct SpringTimingProvider: TimingProvider {
    
    // MARK: Properties
    public let duration: TimeInterval
    public let parameters: UITimingCurveProvider
    
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
    
    // MARK: Initializers
    public init(duration: TimeInterval, parameters: UICubicTimingParameters) {
        self.duration = duration
        self.parameters = parameters
    }
    
    public init(duration: TimeInterval, curve: UIView.AnimationCurve) {
        self.init(duration: duration, parameters: UICubicTimingParameters(animationCurve: curve))
    }
    
    public init(duration: TimeInterval, controlPoint1: CGPoint, controlPoint2: CGPoint) {
        self.init(duration: duration, parameters: UICubicTimingParameters(controlPoint1: controlPoint1, controlPoint2: controlPoint2))
    }
}
