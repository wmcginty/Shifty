//
//  Action.swift
//  Shifty
//
//  Created by William McGinty on 1/6/18.
//

import UIKit

public struct Action {

    // MARK: - Properties
    public let view: UIView
    public let modifier: Modifier
    
    // MARK: - Initializers
    public init(view: UIView, modifier: Modifier) {
        self.view = view
        self.modifier = modifier
    }
}

// MARK: - Interface
public extension Action {
    
    func configuredReplicant(in container: UIView) -> UIView {
        //Create, add and place the replicantView with respect to the container
        let replicant = modifier.configuredShiftingView(for: view)
        container.addSubview(replicant)
        applyPositionalState(to: replicant)
        
        //Configure the native view as hidden so the replicantView is the only visible copy, then return it
        configureNativeView(hidden: true)
        return replicant
    }
    
    func layoutContainerIfNeeded() {
        view.superview?.layoutIfNeeded()
    }
    
    func animate(with replicant: UIView) {
        modifier.modify(replicant)
    }
}

// MARK: - Helper
extension Action {
    
    func applyPositionalState(to view: UIView) {
        snapshot().applyPositionalState(to: view)
    }
    
    func cleanup(replicant: UIView) {
        replicant.removeFromSuperview()
        
        if modifier.restoreNativewView {
            configureNativeView(hidden: false)
        }
    }
    
    /// Returns a `Snapshot` of the current state of the `Target`.
    func snapshot() -> Snapshot {
        return Snapshot(view: view)
    }
    
    func configureNativeView(hidden: Bool) {
        view.isHidden = hidden
    }
}
