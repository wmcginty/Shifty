//
//  ActionGroup.swift
//  Shifty
//
//  Created by William McGinty on 2/7/18.
//

import Foundation

//public struct ActionGroup: ExpressibleByArrayLiteral {
//    
//    // MARK: Properties
//    public let timingContext: TimingContext
//    public let delayFactor: CGFloat
//    public let actions: [Action]
//    
//    // MARK: Initializers
//    public init(animationContext: TimingContext = CubicAnimationContext.default, delayFactor: CGFloat = 0.0, actions: [Action]) {
//        self.timingContext = animationContext
//        self.delayFactor = delayFactor
//        self.actions = actions
//    }
//    
//    public init(arrayLiteral elements: Action...) {
//        self.init(actions: elements)
//    }
//    
//    // MARK: Interface
//    public func animate(with replicantView: UIView) {
//        timingContext.animate {
//            self.actions.forEach { $0.handler(replicantView) }
//        }
//    }
//}
//
//// MARK: Modifications
//public extension ActionGroup {
//    
//    func modifying(delayFactor: CGFloat) -> ActionGroup {
//        assert(delayFactor > 0 && delayFactor < 1)
//        return ActionGroup(animationContext: timingContext, delayFactor: delayFactor, actions: actions)
//    }
//    
//    func modifying(timingContext: TimingContext) -> ActionGroup {
//        return ActionGroup(animationContext: timingContext, delayFactor: delayFactor, actions: actions)
//    }
//    
//    func adding(action: Action) -> ActionGroup {
//        return ActionGroup(animationContext: timingContext, delayFactor: delayFactor, actions: actions + [action])
//    }
//}
