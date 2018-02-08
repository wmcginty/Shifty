//
//  ActionAnimator.swift
//  Shifty
//
//  Created by William McGinty on 1/6/18.
//

import Foundation

public class ActionAnimator {
    
    //MARK: Properties
    let actionReference: [UIView: ActionGroup]
    
        //We use multiple property animators to allow each ActionGroup to occur on a different timing curve. We can also support different overall durations, start delays, etc using keyframes inside the individual animation blocks.
    var animators: [UIView: UIViewPropertyAnimator] = [:]
    
    // MARK: Initializers
    public init(transitionable: ShiftTransitionable) {
        actionReference = Prospector().actionReference(from: transitionable)
    }
    
    // MARK: Interface
    public func animate(withDuration duration: TimeInterval, inContainer container: UIView) {
        actionReference.forEach { (view, actionGroup) in
            
            let animator = configuredAnimator(for: actionGroup, view: view, duration: duration, in: container)
            animator.startAnimation()
            animators[view] = animator
        }
    }
}

// MARK: Action Animations
private extension ActionAnimator {
    
    func configuredAnimator(for group: ActionGroup, view: UIView, duration: TimeInterval, in container: UIView) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: group.animationContext.timingParameters)
        let state = State(view: view, identifier: view.hashValue)
        let replicantView = state.configuredReplicantView(inContainer: container)
        
        animator.addAnimations { group.actionAnimations(for: replicantView) }
        animator.addCompletion { _ in state.cleanupReplicantView(replicantView) }
        
        return animator
    }
}
