//
//  SimpleTransitioningDelegate.swift
//  Shifty
//
//  Created by William McGinty on 7/6/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class SimpleTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    let currentAnimator = SimpleShiftAnimator()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return currentAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return currentAnimator
    }
}
