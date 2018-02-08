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
    public let actions: [Action]
    
    //MARK: Initializers
    public init(animationContext: AnimationContext = CubicAnimationContext.default, actions: [Action]) {
        self.animationContext = animationContext
        self.actions = actions
    }
    
    public init(arrayLiteral elements: Action...) {
        self.init(actions: elements)
    }
    
    //MARK: Interface
    func actionAnimations(for replicantView: UIView) {
        animationContext.animate {
            self.actions.forEach { $0.handler(replicantView) }
        }
    }
}
