//
//  Shift.Target.swift
//  Shifty
//
//  Created by Will McGinty on 5/2/16.
//  Copyright © 2016 will.mcginty. All rights reserved.
//

import UIKit

public extension Shift {

    /// Represents a single target of a shifting `UIView` - usually either the source or the destination.
    struct Target {
        
        // MARK: Properties
        
        /// The view acting as a target of the shift. This view can be either the source or the destination.
        public let view: UIView
        
        /// The identifier assigned to this `Target`. Each identifier in the source will match an identifier in the destination.
        public let identifier: Identifier
        
        /// The method used to configure the view. Defaults to .snapshot.
        public let replicationStrategy: ReplicationStrategy
        
        // MARK: Initializers
        public init(view: UIView, identifier: Identifier, replicationStrategy: ReplicationStrategy = .snapshot) {
            self.view = view
            self.identifier = identifier
            self.replicationStrategy = replicationStrategy
        }
        
        var debug: Target {
            return Target(view: view, identifier: identifier, replicationStrategy: .debug)
        }
    }
}

// MARK: Interface
public extension Shift.Target {
    
    func configuredReplicant(in container: UIView, afterScreenUpdates: Bool) -> UIView {
        //Create, add and place the replicantView with respect to the container
        let replicant = replicationStrategy.configuredShiftingView(for: view, afterScreenUpdates: afterScreenUpdates)
        container.addSubview(replicant)
        
        applyPositionalState(to: replicant, in: container)
        
        return replicant
    }
    
    func applyPositionalState(to view: UIView, in container: UIView) {
        snapshot().applyPositionalState(to: view)
    }
    
    func cleanup(replicant: UIView, restoreNativeView: Bool = true) {
        replicant.removeFromSuperview()
        
        if restoreNativeView {
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

// MARK: Hashable
extension Shift.Target: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    public static func == (lhs: Shift.Target, rhs: Shift.Target) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
