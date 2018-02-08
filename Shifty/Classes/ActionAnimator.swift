//
//  ActionAnimator.swift
//  Shifty
//
//  Created by William McGinty on 1/6/18.
//

import Foundation

public class ActionAnimator {
    
    let actionReference: [UIView: [Action]]
    
    // MARK: Initializers
    public init(transitionable: ShiftTransitionable) {
        actionReference = Prospector().actionReference(from: transitionable)
    }
    
    // MARK: Interface
    public func animate(withDuration duration: TimeInterval, inContainer container: UIView) {
        actionReference.forEach { (view, actions) in
            let state = State(view: view, identifier: view.hashValue)
            let replicantView = state.configuredReplicantView(inContainer: container)
            
            //use a property animator here. allows you to add a completion block. also makes it easier to make interactive.
            actions.forEach { $0.handler(replicantView, duration) }
        }
    }
}
