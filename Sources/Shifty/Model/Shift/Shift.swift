//
//  Shift.swift
//  Shifty
//
//  Created by William McGinty on 12/25/17.
//

import UIKit

/// Represents the shift of a single `UIView` object.
public struct Shift: Hashable {
    
    // MARK: Subtypes
    public struct NativeViewRestorationBehavior: OptionSet, Hashable {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        
        public static let source = NativeViewRestorationBehavior(rawValue: 1 << 0)
        public static let destination = NativeViewRestorationBehavior(rawValue: 1 << 1)
        public static let none: NativeViewRestorationBehavior = []
        public static let all: NativeViewRestorationBehavior = [.source, .destination]
    }
    
    public enum VisualAnimationBehavior {
        case none
        case automatic
        case custom((_ replicant: UIView, _ destination: Snapshot) -> Void)
    }
    
    // MARK: Properties
    public let source: Target
    public let destination: Target
    
    public var nativeViewRestorationBehavior: NativeViewRestorationBehavior = .all
    public var visualAnimationBehavior: VisualAnimationBehavior = .none
    
    // MARK: Initializers
    public init(source: Target, destination: Target) {
        self.source = source
        self.destination = destination
    }
    
    // MARK: Modification
    public var debug: Shift { return Shift(source: source.debug, destination: destination.debug) }
    
    public func visuallyAnimating(using behavior: VisualAnimationBehavior) -> Shift {
        var shift = Shift(source: source, destination: destination)
        shift.visualAnimationBehavior = behavior
        return shift
    }
    
    public func restoringNativeViews(using behavior: NativeViewRestorationBehavior) -> Shift {
        var shift = Shift(source: source, destination: destination)
        shift.nativeViewRestorationBehavior = behavior
        return shift
    }
}

// MARK: Container Management
public extension Shift {
    
    func configuredReplicant(in container: UIView, with insertionStrategy: Target.ReplicantInsertionStrategy = .standard) -> UIView {
        let replicant = source.configuredReplicant(in: container, with: insertionStrategy, afterScreenUpdates: true)
        configureNativeViews(hidden: true)
        
        return replicant
    }
    
    func layoutDestinationIfNeeded() {
        destination.view.superview?.layoutIfNeeded()
    }
    
    func shift(for replicant: UIView, using snapshot: Snapshot?) {
        positionalShift(for: replicant, using: snapshot)
        visualShift(for: replicant, using: snapshot)
    }
}

// MARK: Helper
extension Shift {
    
    func positionalShift(for replicant: UIView, using snapshot: Snapshot? = nil) {
        (snapshot ?? destinationSnapshot()).applyPositionalState(to: replicant)
    }
    
    func visualShift(for replicant: UIView, using snapshot: Snapshot? = nil) {
        let destination = snapshot ?? destinationSnapshot()
        
        switch visualAnimationBehavior {
        case .none: break
        case .automatic: destination.applyVisualState(to: replicant)
        case .custom(let animations): animations(replicant, destination)
        }
    }
    
    func cleanup(replicant: UIView) {
        source.cleanup(replicant: replicant, restoreNativeView: nativeViewRestorationBehavior.contains(.source))
        destination.cleanup(replicant: replicant, restoreNativeView: nativeViewRestorationBehavior.contains(.destination))
    }
    
    func destinationSnapshot() -> Snapshot {
        return destination.snapshot()
    }
    
    func configureNativeViews(hidden: Bool) {
        [source, destination].forEach { $0.configureNativeView(hidden: hidden) }
    }
}

// MARK: Hashable
extension Shift {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(source)
        hasher.combine(destination)
    }
    
    public static func == (lhs: Shift, rhs: Shift) -> Bool {
        return lhs.source == rhs.source && lhs.destination == rhs.destination
    }
}
