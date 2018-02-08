//
//  ActionAnimator.swift
//  Shifty
//
//  Created by William McGinty on 1/6/18.
//

import Foundation

public class ActionAnimator {
    
    let actionReference: [UIView: [Action]]
    
    // MARK: Initializers
    public init(transitionable: ShiftTransitionable) {
        actionReference = Prospector().actionReference(from: transitionable)
    }
    
    // MARK: Interface
    public func animate(withDuration duration: TimeInterval, inContainer container: UIView) {
        actionReference.forEach { (view, actions) in
            actions.forEach { $0.handler(view, duration) }
        }
    }
}
