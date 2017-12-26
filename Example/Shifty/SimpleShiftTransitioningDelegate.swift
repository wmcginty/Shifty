//
//  SimpleShiftTransitioningDelegate.swift
//  Shifty_Example
//
//  Created by William McGinty on 12/26/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class SimpleShiftTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SimpleShiftTransitionAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SimpleShiftTransitionAnimator()
    }
}
