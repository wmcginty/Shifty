//
//  ActionAnimator.swift
//  Shifty
//
//  Created by William McGinty on 1/6/18.
//

import Foundation

public class ActionAnimator {
    
    let actionReference: [UIView: [Action]]
    private var animator: UIViewPropertyAnimator?
    
    // MARK: Initializers
    public init(transitionable: ShiftTransitionable) {
        actionReference = Prospector().actionReference(from: transitionable)
    }
    
    // MARK: Interface
    public func animate(withDuration duration: TimeInterval, inContainer container: UIView) {
        animator = UIViewPropertyAnimator(duration: duration, timingParameters: UICubicTimingParameters(animationCurve: .linear))
        actionReference.forEach { (view, actions) in
            let state = State(view: view, identifier: view.hashValue)
            let replicantView = state.configuredReplicantView(inContainer: container)
            
            actions.forEach { action in
                animator?.addAnimations { action.handler(replicantView) }
            }
            animator?.addCompletion { _ in replicantView.removeFromSuperview() } //needs work, what about different UIViewAnimatingPositions?
        }
        
        animator?.startAnimation()
    }
}
