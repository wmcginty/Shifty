//
//  NavTransitioningDelegate.swift
//  Shifty
//
//  Created by William McGinty on 7/11/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class NavTransitioningDelegate: NSObject, UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if #available(iOS 10, *) {
            return PropertyShiftAnimator()
        } else {
            return SimpleShiftAnimator()
        }
    }
}
