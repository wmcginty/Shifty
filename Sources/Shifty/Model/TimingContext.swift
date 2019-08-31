//
//  AnimationContext.swift
//  Shifty
//
//  Created by William McGinty on 12/29/17.
//

import Foundation

//public struct CubicAnimationContext: TimingContext {
//
//    // MARK: Properties
//    public let cubicTimingParameters: UICubicTimingParameters
//    public let relativeStartTime: TimeInterval
//    public let relativeEndTime: TimeInterval
//
//    // MARK: Initializers
//    public init(timingParameters: UICubicTimingParameters, relativeStartTime: TimeInterval = 0.0, relativeEndTime: TimeInterval = 1.0) {
//        self.cubicTimingParameters = timingParameters
//        self.relativeStartTime = relativeStartTime
//        self.relativeEndTime = relativeEndTime
//    }
//
//    // MARK: AnimationContext
//    public var timingParameters: UITimingCurveProvider { return cubicTimingParameters }
//    public func animate(_ animations: @escaping () -> Void) {
//        //Nesting the animation in a keyframe allows us to take advantage of relative start/end times and inherit the existing animation curve
//        UIView.animateKeyframes(withDuration: 0.0, delay: 0.0, options: [.beginFromCurrentState], animations: {
//            UIView.addKeyframe(withRelativeStartTime: self.relativeStartTime, relativeDuration: self.relativeEndTime - self.relativeStartTime) {
//                animations()
//            }
//        }, completion: nil)
//    }
