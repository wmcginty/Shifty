//
//  ActionAnimator+UIViewImplicitlyAnimating.swift
//  Shifty-iOS
//
//  Created by William McGinty on 9/2/19.
//  Copyright © 2019 Will McGinty. All rights reserved.
//

import UIKit

extension ActionAnimator: UIViewImplicitlyAnimating {
    
    public var state: UIViewAnimatingState { return actionAnimator.state }
    public var isRunning: Bool { return actionAnimator.isRunning }
    
    public var isInterruptible: Bool {
        get { return actionAnimator.isInterruptible }
        set(interruptible) { actionAnimator.isInterruptible = interruptible }
    }
    
    public var isManualHitTestingEnabled: Bool {
        get { return actionAnimator.isManualHitTestingEnabled }
        set(enabled) { actionAnimator.isManualHitTestingEnabled = enabled }
    }
    
    public var scrubsLinearly: Bool {
        get { return actionAnimator.scrubsLinearly }
        set(scrubsLinearly) { actionAnimator.scrubsLinearly = scrubsLinearly }
    }
    
    public var pausesOnCompletion: Bool {
        get { return actionAnimator.pausesOnCompletion }
        set(pausesOnCompletion) { actionAnimator.pausesOnCompletion = pausesOnCompletion }
    }

    public var fractionComplete: CGFloat {
        get { return actionAnimator.fractionComplete }
        set(fractionComplete) { actionAnimator.fractionComplete = fractionComplete }
    }
    
    public var isReversed: Bool {
        get { return actionAnimator.isReversed }
        set(reversed) { actionAnimator.isReversed = reversed }
    }
    
    public func startAnimation() {
        actionAnimator.startAnimation()
    }
    
    public func startAnimation(afterDelay delay: TimeInterval) {
        actionAnimator.startAnimation(afterDelay: delay)
    }
    
    public func pauseAnimation() {
        actionAnimator.pauseAnimation()
    }
    
    public func continueAnimation(withTimingParameters parameters: UITimingCurveProvider?, durationFactor: CGFloat) {
        actionAnimator.continueAnimation(withTimingParameters: parameters, durationFactor: durationFactor)
    }
    
    public func stopAnimation(_ withoutFinishing: Bool) {
        actionAnimator.stopAnimation(withoutFinishing)
    }
    
    public func finishAnimation(at finalPosition: UIViewAnimatingPosition) {
        actionAnimator.finishAnimation(at: finalPosition)
    }
}
