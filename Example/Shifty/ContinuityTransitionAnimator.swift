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
        guard let sourceController = transitionContext.viewController(forKey: .from), let destinationController = transitionContext.viewController(forKey: .to) else { return }
        guard let destinationView = transitionContext.view(forKey: .to) else { return }
        guard let source = sourceController as? TransitionRespondable, let destination = destinationController as? TransitionRespondable else { return }
        
        /*First, we'll instruct the source to respond to the beginning of the transition. Because we want to immediately swap out the
         views and end the 'transition' before allowing the destination to complete it. We'll pass the entire transition duration to this
         preparation (for animations). Meanwhile, we'll create our destinationView and allow it to prepare for the incoming transition (so
         it can do things like clear out it's view, etc). */
        
        let actionAnimator = ActionAnimator(transitionable: source as! ShiftTransitionable)
        actionAnimator.execute()
        //print(actionAnimator)
        
//        destination.prepareForTransition(from: source)
//        source.prepareForTransition(to: destination, withDuration: transitionDuration(using: transitionContext)) { finished in
//
//            //At this point, the source has been able to prepare. The implicit requirement for this particular transition is that the view needs to be clear at this point. Now, assuming the backgrounds of the views match we can swap in the destination (with no visual effect - so it all looks like one controller) and allow it to animate it's elements on screen.
//
//            container.addSubview(destinationView)
//            destinationView.frame = transitionContext.finalFrame(for: destinationController)
//
//            //Now, the destination is on screen and ready to complete the transition. But we don't need to include that 'entrance' animation in our transition. So we'll simultaneously give our source time to clean up after transitioning to the destination, tell the destination to perform any 'complete animations/work' and tell the context we're finished.
//
//            //source.completeTransition(to: destination)
//            destination.completeTransition(from: source)
//            transitionContext.completeTransition(finished)
//        }
    }
}
