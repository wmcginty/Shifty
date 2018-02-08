//
//  SimpleShiftAnimator.swift
//  Shifty
//
//  Created by William McGinty on 7/6/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Shifty

/** A transition with the implicit contract that the source will animate all of it's contents off screen to a point where it's visual
 state matches that of the destination. The destination will then be instantaneously swapped on screen and be given the chance to
 complete any entrance animations to reach it's final visual state. */
class ContinuityTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
        
    // MARK: UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //Begin by ensuring the transitionContext is configured correctly, and that our source + destination can power the transition. This being a basic example - exit if this fails, no fallbacks. YMMV with more complicated examples.
        
        let container = transitionContext.containerView
        guard let sourceController = transitionContext.viewController(forKey: .from)/*, let destinationController = transitionContext.viewController(forKey: .to)*/ else { return }
        //guard _ = transitionContext.view(forKey: .to) else { return }
        guard let source = sourceController as? ShiftTransitionable/*, _ = destinationController as? ShiftTransitionable*/ else { return }
        
        /* First, create an ActionAnimator */
        
        let actionAnimator = ActionAnimator(transitionable: source)
        actionAnimator.animate(withDuration: transitionDuration(using: transitionContext), inContainer: container)
        
//
//            source.completeTransition(to: destination)
//            destination.completeTransition(from: source)
//            transitionContext.completeTransition(finished)
//        }
    }
}
