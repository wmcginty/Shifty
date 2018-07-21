//
//  Action.swift
//  Shifty
//
//  Created by William McGinty on 1/6/18.
//

import UIKit

public struct Action {
    
    // MARK: Properties
    public let handler: (UIView) -> Void
    
    // MARK: Initializers
    public init(handler: @escaping (UIView) -> Void) {
        self.handler = handler
    }
}

// MARK: Presets
public extension Action {
    
    static func fade(to alpha: CGFloat) -> Action {
        return Action { $0.alpha = alpha }
    }
    
    static func transform(to transform: CGAffineTransform) -> Action {
        return Action { $0.transform = $0.transform.concatenating(transform) }
    }
    
    static func scale(toX x: CGFloat, y: CGFloat) -> Action {
        return transform(to: CGAffineTransform(scaleX: x, y: y))
    }
    
    static func rotate(to angle: CGFloat) -> Action {
        return transform(to: CGAffineTransform(rotationAngle: angle))
    }
    
    static func translate(byX x: CGFloat, y: CGFloat) -> Action {
        return transform(to: CGAffineTransform(translationX: x, y: y))
    }
}

// MARK: [Action] Extensions
public extension Array where Element == Action {
    
    func modifying(delayFactor: CGFloat) -> ActionGroup {
        return ActionGroup(delayFactor: delayFactor, actions: self)
    }
    
    func modifying(timingContext: TimingContext) -> ActionGroup {
        return ActionGroup(animationContext: timingContext, actions: self)
    }
    
    func adding(action: Action) -> ActionGroup {
        return ActionGroup(actions: self + [action])
    }
}
