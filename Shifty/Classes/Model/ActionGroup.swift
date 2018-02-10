//
//  ActionGroup.swift
//  Shifty
//
//  Created by William McGinty on 2/7/18.
//

import Foundation

public struct ActionGroup: ExpressibleByArrayLiteral {
    
    //MARK: Properties
    public let animationContext: AnimationContext
    public let delay: TimeInterval
    public let delayFactor: CGFloat
    public let actions: [Action]
    
    //MARK: Initializers
    public init(animationContext: AnimationContext = CubicAnimationContext.default, delay: TimeInterval = 0.0, delayFactor: CGFloat = 0.0, actions: [Action]) {
        self.animationContext = animationContext
        self.delay = delay
        self.delayFactor = delayFactor
        self.actions = actions
    }
    
    public init(arrayLiteral elements: Action...) {
        self.init(actions: elements)
    }
    
    //MARK: Interface
    public func actionAnimations(for replicantView: UIView) {
        animationContext.animate {
            self.actions.forEach { $0.handler(replicantView) }
        }
    }
}

//MARK: Modifications
public extension ActionGroup {
    
    func delayed(by interval: TimeInterval) -> ActionGroup {
        return ActionGroup(animationContext: animationContext, delay: interval, delayFactor: delayFactor, actions: actions)
    }
    
    func with(delayFactor: CGFloat) -> ActionGroup {
        return ActionGroup(animationContext: animationContext, delay: delay, delayFactor: delayFactor, actions: actions)
    }
    
    func with(animationContext: AnimationContext) -> ActionGroup {
        return ActionGroup(animationContext: animationContext, delay: delay, delayFactor: delayFactor, actions: actions)
    }
    
    func adding(action: Action) -> ActionGroup {
        return ActionGroup(animationContext: animationContext, delay: delay, delayFactor: delayFactor, actions: actions + [action])
    }
}
