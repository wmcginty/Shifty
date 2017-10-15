//
//  UIViewPropertyAnimator+ShiftAction.swift
//  Pods
//
//  Created by William McGinty on 9/14/16.
//
//

import UIKit

@available(iOS 10, *)
extension UIViewPropertyAnimator {
    
    func add(_ shiftAction: ShiftAction) {
        addAnimations(shiftAction.animations)
        add(completion: shiftAction.completion)
    }
    
    func add(completion: AnimationCompletion?) {
        addCompletion { position in
            switch position {
            case .start: completion?(false) //We're at the start - we didn't finish
            case .current: fatalError("say whattt?")
            case .end: completion?(true) //We're at the end - we finished
            }
        }
    }
}
