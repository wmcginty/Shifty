//
//  Array+Actions.swift
//  Shift
//
//  Created by William McGinty on 2/9/18.
//

import Foundation

public extension Array where Element == Action {
    
    func with(delayFactor: CGFloat) -> ActionGroup {
        return ActionGroup(delayFactor: delayFactor, actions: self)
    }
    
    func with(animationContext: AnimationContext) -> ActionGroup {
        return ActionGroup(animationContext: animationContext, actions: self)
    }
    
    func adding(action: Action) -> ActionGroup {
        return ActionGroup(actions: self + [action])
    }
}
