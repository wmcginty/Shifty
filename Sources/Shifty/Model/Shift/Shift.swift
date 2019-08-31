//
//  Shift.swift
//  Shifty
//
//  Created by William McGinty on 12/25/17.
//

import UIKit

/// Represents the shift of a single `UIView` object.
public struct Shift: Hashable {
    
    // MARK: Subtype
    public struct NativeViewRestorationBehavior: OptionSet, Hashable {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        
        public static let source = NativeViewRestorationBehavior(rawValue: 1 << 0)
        public static let destination = NativeViewRestorationBehavior(rawValue: 1 << 1)
        public static let none: NativeViewRestorationBehavior = []
        public static let all: NativeViewRestorationBehavior = [.source, .destination]
    }
    
    // MARK: Properties
    public let source: Target
    public let destination: Target
    
    public var isPositionalOnly: Bool = false
    public var nativeViewRestorationBehavior: NativeViewRestorationBehavior = .all
    
    // MARK: Initializers
    public init(source: Target, destination: Target) {
        self.source = source
        self.destination = destination
    }
    
    var debug: Shift {
        var shift = Shift(source: source.debug, destination: destination.debug)
        shift.isPositionalOnly = true
        
        return shift
    }
}

// MARK: Container Management
public extension Shift {
    
    func configuredReplicant(in container: UIView) -> UIView {
        let replicant = source.configuredReplicant(in: container, afterScreenUpdates: true)
        configureNativeViews(hidden: true)
        
        return replicant
    }
    
    func layoutDestinationIfNeeded() {
        destination.view.superview?.layoutIfNeeded()
    }
    
    func shift(for replicant: UIView) {
        positionalShift(for: replicant)
        visualShift(for: replicant)
    }
    
    func positionalShift(for replicant: UIView) {
        destinationSnapshot().applyPositionalState(to: replicant)
    }
    
    func visualShift(for replicant: UIView) {
        if !isPositionalOnly {
            #if DEBUG
            if !source.replicationStrategy.canVisuallyShift {
                debugPrint("Shifty Warning: Using the snapshot replication strategy can not accomodate visual shifts (only positional).")
            }
            #endif
            
            destinationSnapshot().applyVisualState(to: replicant)
        }
    }
    
    func cleanup(replicant: UIView) {
        source.cleanup(replicant: replicant, restoreNativeView: nativeViewRestorationBehavior.contains(.source))
        destination.cleanup(replicant: replicant, restoreNativeView: nativeViewRestorationBehavior.contains(.destination))
    }
}

// MARK: Snapshots
public extension Shift {
    
    func destinationSnapshot() -> Snapshot {
        return destination.snapshot()
    }
    
    func configureNativeViews(hidden: Bool) {
        [source, destination].forEach { $0.configureNativeView(hidden: hidden) }
    }
}
