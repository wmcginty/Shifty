//
//  ActionAnimator.swift
//  Shifty
//
//  Created by William McGinty on 1/6/18.
//

import Foundation

public class ActionAnimator: NSObject {

    // MARK: Properties
    public let timingProvider: TimingProvider
    public let actionAnimator: UIViewPropertyAnimator
    public var isReversed: Bool = false

    // MARK: Initializers
    public init(timingProvider: TimingProvider) {
        self.timingProvider = timingProvider
        self.actionAnimator = UIViewPropertyAnimator(duration: timingProvider.duration, timingParameters: timingProvider.parameters)
    }

    // MARK: Interface
    open func animate(_ actions: [Action], in container: UIView, completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        configureActionAnimators(for: actions, in: container, completion: completion)
        startAnimation()
    }
}

// MARK: Helper
private extension ActionAnimator {
    
    func configureActionAnimators(for actions: [Action], in container: UIView, completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        actions.forEach { action in
            
            let replicant = action.configuredReplicant(in: container)
            action.layoutContainerIfNeeded()
            
            actionAnimator.addAnimations { [weak self] in
                self?.animations(for: action, with: replicant)
            }
            
            actionAnimator.addCompletion { _ in
                action.cleanup(replicant: replicant)
            }
        }
        
        actionAnimator.isReversed = isReversed
        completion.map(actionAnimator.addCompletion)
    }
 
    func animations(for action: Action, with replicant: UIView) {
        guard let keyframe = timingProvider.keyframe else {
            return action.animate(with: replicant)
        }
        
        UIView.animateKeyframes(withDuration: 0.0, delay: 0.0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: keyframe.startTime, relativeDuration: keyframe.duration) {
                action.animate(with: replicant)
            }
        }, completion: nil)
    }
}
