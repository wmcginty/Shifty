//
//  ReplicationStrategy.swift
//  Shifty
//
//  Created by William McGinty on 8/30/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

public enum ReplicationStrategy {
    public typealias Configurator = (_ baseView: UIView) -> UIView
    
    case snapshot
    case configured(Configurator)
    case none
    
    // MARK: Interface
    var canVisuallyShift: Bool {
        switch self {
        case .snapshot: return false
        default: return true
        }
    }
    
    public func configuredShiftingView(for baseView: UIView, afterScreenUpdates: Bool) -> UIView {
        switch self {
        case .snapshot: return snapshot(of: baseView, afterScreenUpdates: afterScreenUpdates)
        case .configured(let configurator): return configurator(baseView)
        case .none: return baseView
        }
    }
}

// MARK: Helper
private extension ReplicationStrategy {
    
    func snapshot(of baseView: UIView, afterScreenUpdates: Bool) -> SnapshotView {
        //Ensure we take the snapshot with no corner radius, and then apply that radius to the snapshot (and reset the baseView).
        let cornerRadius = baseView.layer.cornerRadius
        baseView.layer.cornerRadius = 0
        
        guard let contentView = baseView.snapshotView(afterScreenUpdates: afterScreenUpdates) else { fatalError("Unable to snapshot view: \(baseView)") }
        let snapshot = SnapshotView(contentView: contentView)
        
        //Apply the known corner radius to both the replicant view and the base view
        snapshot.layer.cornerRadius = cornerRadius
        snapshot.layer.masksToBounds = cornerRadius > 0
        
        baseView.layer.cornerRadius = cornerRadius
        
        return snapshot
    }
}

// MARK: Convenience
public extension ReplicationStrategy {
    
    static let replication = ReplicationStrategy.configured { baseView -> UIView in
        return baseView.replicant
    }
    
    static let debug = ReplicationStrategy.configured { baseView -> UIView in
        let copy = UIView(frame: baseView.frame)
        copy.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        copy.layer.cornerRadius = baseView.layer.cornerRadius
        copy.layer.masksToBounds = baseView.layer.masksToBounds
        
        return copy
    }
}
