//
//  ContinuityTransitioningDelegate.swift
//  Shifty_Example
//
//  Created by William McGinty on 12/25/17.
//  Copyright © 2017 Will McGinty. All rights reserved.
//

import UIKit

class ContinuityTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ContinuityTransitionAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ContinuityTransitionAnimator()
    }
}
