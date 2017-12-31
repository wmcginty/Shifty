//
//  State.swift
//  Shifty
//
//  Created by Will McGinty on 5/2/16.
//  Copyright © 2016 will.mcginty. All rights reserved.
//

import UIKit

// MARK: State Struct

/// Represents a single state of a shifting `UIView`.
public struct State {
    
    public enum Configuration {
        public typealias Configurator = (_ baseView: UIView) -> UIView
        
        case snapshot
        case configured(Configurator)
        
        // MARK: Interface
        func configuredShiftingView(for baseView: UIView) -> UIView {
            switch self {
            case .snapshot:
                //Ensure we take the snapshot with no corner radius, and then apply that radius to the snapshot (and reset the baseView).
                let cornerRadius = baseView.layer.cornerRadius
                baseView.layer.cornerRadius = 0
                
                guard let s = baseView.snapshotView(afterScreenUpdates: true) else { fatalError("Unable to snapshot view: \(baseView)") }
                let snapshot = SnapshotView(contentView: s)
                
                snapshot.layer.masksToBounds = true
                snapshot.layer.cornerRadius = cornerRadius
                baseView.layer.cornerRadius = cornerRadius
                
                return snapshot
                
            case .configured(let configurator):
                return configurator(baseView)
            }
        }
    }
    
    // MARK: Properties
    public let view: UIView /// The view being subjected to the shift.
    public let identifier: AnyHashable /// The identifier assigned to this `State`. Each identifier in the source should match an identifier in the destination.
    public let configuration: Configuration /// The method used to configure the view. Defaults to .snapshot.
    
    // MARK: Initializers    
    public init(view: UIView, identifier: AnyHashable, configuration: Configuration = .snapshot) {
        self.view = view
        self.identifier = identifier
        self.configuration = configuration
    }
}

// MARK: Public Interface
public extension State {
    
    func viewForShiftWithRespect(to container: UIView) -> UIView {
        return configuration.configuredShiftingView(for: view)
    }
    
    func applyState(to view: UIView, in container: UIView) {
        currentSnapshot().applyState(to: view, in: container)
    }
}

// MARK: Internal Interface
extension State {
    
    /// Returns a `Snapshot` of the current state of the `State`.
    func currentSnapshot() -> Snapshot {
        return Snapshot(view: view)
    }
}

// MARK: Hashable
extension State: Hashable {
    
    public var hashValue: Int {
        return identifier.hashValue
    }
    
    public static func == (lhs: State, rhs: State) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
