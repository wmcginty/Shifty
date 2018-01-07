//
//  ActionAnimator.swift
//  Shifty
//
//  Created by William McGinty on 1/6/18.
//

import Foundation

public class ActionAnimator {
    
    let actionReference: [UIView: [Action]]
    
    public init(transitionable: ShiftTransitionable) {
        actionReference = Prospector().actionReference(from: transitionable)
        print(actionReference)
    }
    
    public func execute() {
        actionReference.forEach { key, value in
            value.forEach {
                $0.handler(key)
            }
        }
    }
}
