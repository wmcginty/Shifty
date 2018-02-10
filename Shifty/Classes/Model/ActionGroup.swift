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
    public let delayFactor: CGFloat
    public let actions: [Action]
    
    //MARK: Initializers
    public init(animationContext: AnimationContext = CubicAnimationContext.default, delayFactor: CGFloat = 0.0, actions: [Action]) {
        self.animationContext = animationContext
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
    
    func with(delayFactor: CGFloat) -> ActionGroup {
        assert(delayFactor > 0 && delayFactor < 1)
        return ActionGroup(animationContext: animationContext, delayFactor: delayFactor, actions: actions)
    }
    
    func with(animationContext: AnimationContext) -> ActionGroup {
        return ActionGroup(animationContext: animationContext, delayFactor: delayFactor, actions: actions)
    }
    
    func adding(action: Action) -> ActionGroup {
        return ActionGroup(animationContext: animationContext, delayFactor: delayFactor, actions: actions + [action])
    }
}
