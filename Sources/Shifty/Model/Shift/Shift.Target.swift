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
        
        // MARK: - Typealias
        public typealias AlongsideAnimation = (_ replicant: UIView, _ destination: Shift.Target, _ snapshot: Snapshot) -> Void
        
        // MARK: - ReplicantInsertionStrategy Subtype
        public enum ReplicantInsertionStrategy {
            case standard
            case above(UIView)
            case below(UIView)
            case custom((_ replicant: UIView, _ container: UIView) -> Void)
            
            func insert(replicant: UIView, into container: UIView) {
                switch self {
                case .standard: container.addSubview(replicant)
                case .above(let other): container.insertSubview(replicant, aboveSubview: other)
                case .below(let other): container.insertSubview(replicant, belowSubview: other)
                case .custom(let handler): handler(replicant, container)
                }
            }
        }
        
        // MARK: - Properties
        
        /// The view acting as a target of the shift. This view can be either the source or the destination.
        public let view: UIView
        
        /// The identifier assigned to this `Target`. Each identifier in the source will match an identifier in the destination.
        public let identifier: Identifier
        
        /// The method used to configure the view. Defaults to .snapshot.
        public let replicationStrategy: ReplicationStrategy

        /// A set of animations that will be executed simultaneously with animations that drive the shift (both positional and visual).
        /// - Important: In the case that the `Shift` is utilizing a `VisualAnimationBehavior` not equal to `.none`, these animations will take precendence - though creating an
        ///  animation that contradicts an animation created by the `VisualAnimationBehavior` may produce undesirable visual side effects.
        public var alongsideAnimations: AlongsideAnimation?
        
        // MARK: - Initializers
        public init(view: UIView, identifier: Identifier, replicationStrategy: ReplicationStrategy = .snapshot, alongsideAnimations: AlongsideAnimation? = nil) {
            self.view = view
            self.identifier = identifier
            self.replicationStrategy = replicationStrategy
            self.alongsideAnimations = alongsideAnimations
        }
        
        // MARK: - Modification
        var debug: Target { return Target(view: view, identifier: identifier, replicationStrategy: .debug()) }
        
        public func replicating(using strategy: ReplicationStrategy) -> Shift.Target {
            return Shift.Target(view: view, identifier: identifier, replicationStrategy: strategy)
        }
    }
}

// MARK: - Interface
public extension Shift.Target {
    
    func configuredReplicant(in container: UIView, with insertionStrategy: ReplicantInsertionStrategy = .standard, afterScreenUpdates: Bool) -> UIView {
        let replicant = replicationStrategy.configuredShiftingView(for: view, afterScreenUpdates: afterScreenUpdates)
        insertionStrategy.insert(replicant: replicant, into: container)
    
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

// MARK: - Hashable
extension Shift.Target: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    public static func == (lhs: Shift.Target, rhs: Shift.Target) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
