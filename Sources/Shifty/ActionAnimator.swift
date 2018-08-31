//
//  ActionAnimator.swift
//  Shifty
//
//  Created by William McGinty on 1/6/18.
//

import Foundation

public class ActionAnimator {
    
    // MARK: Properties
    let actionReference: [UIView: ActionGroup]
    var isInverted: Bool
    var viewConfiguration: State.Configuration
    
    //We use multiple property animators to allow each ActionGroup to occur on a different timing curve. This also means we can support different overall durations and delays using keyframes inside the individual `TimingContext`s.
    private var animators: [UIView: UIViewPropertyAnimator] = [:]
    
    // MARK: Initializers
    public init(transitionable: ShiftTransitionable, isInverted: Bool = false, viewConfiguration: State.Configuration = .snapshot) {
        self.actionReference = Prospector.actionReference(from: transitionable)
        self.isInverted = isInverted
        self.viewConfiguration = viewConfiguration
    }
    
    // MARK: Interface
    public func animate(withDuration duration: TimeInterval, inContainer container: UIView, completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        let actionPairs = actionReference.map { (view: $0.key, actionGroup: $0.value) }
        
        actionPairs.enumerated().forEach { idx, pair in
            let animator = configuredAnimator(for: pair.actionGroup, view: pair.view, duration: duration, in: container)
            if let completion = completion, idx == actionPairs.startIndex {
                animator.addCompletion(completion)
            }
            
            animators[pair.view] = animator
            animator.startAnimation()
        }
    }
}

// MARK: Helper
private extension ActionAnimator {
    
    func configuredAnimator(for group: ActionGroup, view: UIView, duration: TimeInterval, in container: UIView) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: group.timingContext.timingParameters)
        let state = State(view: view, identifier: view.hashValue, configuration: viewConfiguration)
        let replicantView = state.configuredReplicantView(inContainer: container, afterScreenUpdates: isInverted)
        
        animator.addAnimations({ group.animate(with: replicantView) }, delayFactor: group.delayFactor)
        animator.addCompletion { _ in state.cleanupReplicantView(replicantView) }
        
        if isInverted {
            animator.fractionComplete = 1
            animator.isReversed = true
        }
        
        return animator
    }
}
