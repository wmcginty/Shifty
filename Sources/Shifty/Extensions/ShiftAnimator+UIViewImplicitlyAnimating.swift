//
//  ShiftAnimator+UIViewImplicitlyAnimating.swift
//  Shifty
//
//  Created by William McGinty on 1/7/18.
//

import Foundation

// MARK: UIViewImplicitlyAnimating
extension ShiftAnimator: UIViewImplicitlyAnimating {
    
    private var representativeAnimator: UIViewPropertyAnimator? {
        return animators.values.first
    }
    
    public var state: UIViewAnimatingState {
        return representativeAnimator?.state ?? .inactive
    }
    
    public var isRunning: Bool {
        return representativeAnimator?.isRunning ?? false
    }
    
    public var isReversed: Bool {
        get { return representativeAnimator?.isReversed ?? false }
        set {
            animators.values.forEach { $0.isReversed = newValue }
        }
    }
    
    public var fractionComplete: CGFloat {
        get { return representativeAnimator?.fractionComplete ?? 0 }
        set {
            animators.values.forEach { $0.fractionComplete = fractionComplete }
        }
    }
    
    public func startAnimation() {
        animators.values.forEach { $0.startAnimation() }
    }
    
    public func startAnimation(afterDelay delay: TimeInterval = 0.0) {
        animators.values.forEach { $0.startAnimation(afterDelay: delay) }
    }
    
    public func pauseAnimation() {
        animators.values.forEach { $0.pauseAnimation() }
    }
    
    public func stopAnimation(_ withoutFinishing: Bool) {
        animators.values.forEach { $0.stopAnimation(withoutFinishing) }
    }
    
    public func finishAnimation(at finalPosition: UIViewAnimatingPosition) {
        animators.values.forEach { $0.finishAnimation(at: finalPosition) }
    }
}
