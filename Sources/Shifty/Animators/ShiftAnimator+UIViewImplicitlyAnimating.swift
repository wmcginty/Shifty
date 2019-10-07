//
//  ShiftAnimator+UIViewImplicitlyAnimating.swift
//  Shifty-iOS
//
//  Created by William McGinty on 8/31/19.
//  Copyright © 2019 Will McGinty. All rights reserved.
//

import UIKit

extension ShiftAnimator: UIViewImplicitlyAnimating {
    
    public var state: UIViewAnimatingState { return shiftAnimator.state }
    public var isRunning: Bool { return shiftAnimator.isRunning }
    
    public var isInterruptible: Bool {
        get { return shiftAnimator.isInterruptible }
        set(interruptible) { shiftAnimator.isInterruptible = interruptible }
    }
    
    public var isManualHitTestingEnabled: Bool {
        get { return shiftAnimator.isManualHitTestingEnabled }
        set(enabled) { shiftAnimator.isManualHitTestingEnabled = enabled }
    }
    
    public var scrubsLinearly: Bool {
        get { return shiftAnimator.scrubsLinearly }
        set(scrubsLinearly) { shiftAnimator.scrubsLinearly = scrubsLinearly }
    }
    
    public var pausesOnCompletion: Bool {
        get { return shiftAnimator.pausesOnCompletion }
        set(pausesOnCompletion) { shiftAnimator.pausesOnCompletion = pausesOnCompletion }
    }
    
    public var isReversed: Bool {
        get { return shiftAnimator.isReversed }
        set(reversed) { shiftAnimator.isReversed = reversed }
    }
    
    public var fractionComplete: CGFloat {
        get { return shiftAnimator.fractionComplete }
        set(fractionComplete) { shiftAnimator.fractionComplete = fractionComplete }
    }
    
    public func startAnimation() {
        shiftAnimator.startAnimation()
    }
    
    public func startAnimation(afterDelay delay: TimeInterval) {
        shiftAnimator.startAnimation(afterDelay: delay)
    }
    
    public func pauseAnimation() {
        shiftAnimator.pauseAnimation()
    }
    
    public func continueAnimation(withTimingParameters parameters: UITimingCurveProvider?, durationFactor: CGFloat) {
        shiftAnimator.continueAnimation(withTimingParameters: parameters, durationFactor: durationFactor)
    }
    
    public func stopAnimation(_ withoutFinishing: Bool) {
        shiftAnimator.stopAnimation(withoutFinishing)
    }
    
    public func finishAnimation(at position: UIViewAnimatingPosition) {
        shiftAnimator.finishAnimation(at: position)
    }
}
