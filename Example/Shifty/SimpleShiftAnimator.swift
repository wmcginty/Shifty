//
//  SimpleShiftAnimator.swift
//  Shifty
//
//  Created by William McGinty on 7/6/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Shifty

class SimpleShiftAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        //Begin by ensuring the transitionContext is configured correctly, and that our source + destination can power the transition
        guard let sourceViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let destinationViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            fatalError("Improperly configured transition context: \(transitionContext)")
        }
        
        guard let sourceView = transitionContext.view(forKey: UITransitionContextViewKey.from),
            let destinationView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            fatalError("Improperly configured transition context: \(transitionContext)")
        }
        
        guard let sourceVC = sourceViewController as? ContinuityTransitionable, let destinationVC = destinationViewController as? ContinuityTransitionable else {
            fatalError("Can not perform a shift animation with non ContinuityTransitionable controllers")
        }
        
        let containerView = transitionContext.containerView
        
        //Configure the destination ahead of it's presentation
        destinationView.frame = transitionContext.finalFrame(for: destinationViewController)
        (destinationVC as? ContinuityTransitionPreparable)?.prepareForTransition(from: sourceViewController)
        
        //Begin the transitioning process by tellign the source to prepare
        sourceVC.prepareForTransition(to: destinationViewController, withDuration: transitionDuration(using: transitionContext)) { [unowned self] (finished) in
        
            //As soon as the source has finished preparations, add the (hidden) destination view so that we can properly place our shifting views.
            destinationView.isHidden = true
            containerView.insertSubview(destinationView, aboveSubview: sourceView)
        
            //Next, we will begin the frame shift animation and unhide the destination view - because the continuity transition is designed for view controllers with identical backgrounds - this is imperceptible.
            let frameShiftAnimator = self.initializeFrameShiftAnimatorWith(sourceViewController, destinationViewController: destinationViewController)
            frameShiftAnimator?.performFrameShiftAnimations(in: containerView, with: destinationView, over: self.transitionDuration(using: transitionContext))
            destinationView.isHidden = false
            
            //At this point, we can tell the destination to complete the transition and provide the source a chance to clean up before cleaning up the context itself.
            destinationVC.completeTransition(from: sourceViewController)
            (sourceVC as? ContinuityTransitionPreparable)?.completeTransition(to: destinationViewController)
            
            transitionContext.completeTransition(true)
        }
    }
}

//MARK: Private Helpers
private extension SimpleShiftAnimator {
    
    func initializeFrameShiftAnimatorWith(_ sourceViewController: UIViewController, destinationViewController: UIViewController) -> FrameShiftAnimatorType? {
        guard let source = sourceViewController as? FrameShiftable,
            let destination = destinationViewController as? FrameShiftable else { return .none }
        
        return FrameShiftAnimator(source: source, destination: destination)
    }
}
