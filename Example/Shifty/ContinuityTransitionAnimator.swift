//
//  SimpleShiftAnimator.swift
//  Shifty
//
//  Created by William McGinty on 7/6/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Shifty

/** An example UIViewControllerAnimatedTransitioning object designed to make movement between similar screens seamless, appearing
 as a single screen. This animator functions in many scenarios, but functions best with view controllers with similar backgrounds. */
class ContinuityTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
        
    // MARK: UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        /** Begin by ensuring the transitionContext is configured correctly, and that our source + destination can power the transition.
         This being a basic example - exit if this fails, no fallbacks. YMMV with more complicated examples. */
        let container = transitionContext.containerView
        guard let sourceController = transitionContext.viewController(forKey: .from), let destinationController = transitionContext.viewController(forKey: .to) else { return }
        guard let destinationView = transitionContext.view(forKey: .to) else { return }
        guard let source = sourceController as? ShiftTransitionable, let destination = destinationController as? ShiftTransitionable else { return }
        
        //Next, add and position the destinationView ABOVE the sourceView
        container.addSubview(destinationView)
        destinationView.frame = transitionContext.finalFrame(for: destinationController)
        
        /** Next, we will create a source animator, and instruct it to animate. This will gather all the subviews of `source` with associated `actions` and
         animate them simultaneously using the options specified to the animator. As soon as the source's actions have completed, the transition can finish. */
        let sourceAnimator = ActionAnimator(transitionable: source)
        sourceAnimator.animate(withDuration: transitionDuration(using: transitionContext), inContainer: container) { _ in
            transitionContext.completeTransition(true)
        }
        
        /** Finally, we'll create another animator for the destination. Because these animations have no bearing on the final state of this transition, they can be
         carried out regardless of the state of the transition itself (ie, the transition does not need to finish AFTER these animations finish). */
        let destinationAnimator = ActionAnimator(transitionable: destination, isInverted: true)
        destinationAnimator.animate(withDuration: self.transitionDuration(using: transitionContext), inContainer: container)
    }
}
