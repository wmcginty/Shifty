//
//  PrecommitShiftTransitionAnimator.swift
//  Shifty_Example
//
//  Created by William McGinty on 12/26/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Shifty

/// A transition with the implicit contract that the source will animate all of it's contents off screen to a point where it's visual state matches that of the destination. The destination will then be instantaneously swapped on screen and be given the chance to complete any entrance animations to reach it's final visual state.
class PrecommitShiftTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var shiftAnimator: ShiftAnimator?
    
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
        guard let shiftSource = sourceController as? ShiftTransitionable, let shiftDestination = destinationController as? ShiftTransitionable else { return }
        
        //First, we'll instruct the source to respond to the beginning of the transition. Because we want to immediately swap out the views and end the 'transition' before allowing the destination to complete it. We'll pass the entire transition duration to this preparation (for animations). Meanwhile, we'll create our destinationView and allow it to prepare for the incoming transition (so it can do things like clear out it's view, etc).
        
        shiftAnimator = ShiftAnimator(source: shiftSource, destination: shiftDestination,
                                      coordinator: DefaultShiftCoordinator(timingCurveProvider: UISpringTimingParameters(dampingRatio: 0.7)))
        
        destination.prepareForTransition(from: source)
        source.prepareForTransition(to: destination, withDuration: transitionDuration(using: transitionContext)) { finished in
            
            container.addSubview(destinationView)
            destinationView.frame = transitionContext.finalFrame(for: destinationController)
            destinationView.layoutIfNeeded()
            
            self.shiftAnimator?.commitShifts()
            destinationView.transform = CGAffineTransform(translationX: 0, y: container.bounds.height)
            
            let duration = 0.3
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
                destinationView.transform = .identity
            }, completion: nil)
            
            source.completeTransition(to: destination)
            destination.completeTransition(from: source)
            self.shiftAnimator?.animate(with: duration, inContainer: container) { position in
                transitionContext.completeTransition(position == .end)
            }
        }
    }
}
