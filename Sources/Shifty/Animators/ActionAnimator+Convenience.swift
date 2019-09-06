//
//  ActionAnimator+Convenience.swift
//  Shifty-iOS
//
//  Created by William McGinty on 9/4/19.
//  Copyright © 2019 Will McGinty. All rights reserved.
//

import Foundation

public extension ActionAnimator {
    
    func animateActions(from source: UIView, in container: UIView, completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        let locator = ActionLocator()
        animate(locator.actions(in: source), in: container, completion: completion)
    }
}
