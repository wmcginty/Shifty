//
//  Shift.swift
//  Shifty
//
//  Created by William McGinty on 12/25/17.
//

import UIKit

/// Represents the shift of a single `UIView` object.
public struct Shift: Hashable {
    
    // MARK: NativeViewRestorationBehavior Subtype
    public struct NativeViewRestorationBehavior: OptionSet, Hashable {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        
        public static let source = NativeViewRestorationBehavior(rawValue: 1 << 0)
        public static let destination = NativeViewRestorationBehavior(rawValue: 1 << 1)
        public static let none: NativeViewRestorationBehavior = []
        public static let all: NativeViewRestorationBehavior = [.source, .destination]
    }
    
    // MARK: VisualAnimationBehavior Subtype
    public enum VisualAnimationBehavior {
        
        // MARK: Custom Subtype
        public struct Custom {
            
            // MARK: Typealias
            public typealias Handler = (_ replicant: UIView, _ destination: Snapshot) -> Void
            
            // MARK: Properties
            private let preparations: Handler?
            private let animations: Handler
            
            // MARK: Initializers
            public init(preparations: Handler? = nil, animations: @escaping Handler) {
                self.preparations = preparations
                self.animations = animations
            }
            
            // MARK: Interface
            func prepare(replicant: UIView, with snapshot: Snapshot) {
                preparations?(replicant, snapshot)
            }
            
            func animate(replicant: UIView, to snapshot: Snapshot) {
                animations(replicant, snapshot)
            }
        }
        
        case none
        case automatic
        case custom(Custom)
    }
    
    // MARK: Properties
    public let identifier: Shift.Identifier
    public let source: Target
    public let destination: Target
    
    public var nativeViewRestorationBehavior: NativeViewRestorationBehavior = .all
    public var visualAnimationBehavior: VisualAnimationBehavior = .none
    
    // MARK: Initializers
    public init(identifier: Shift.Identifier, source: Target, destination: Target) {
        self.identifier = identifier
        self.source = source
        self.destination = destination
    }
    
    // MARK: Modification
    public var debug: Shift { return Shift(identifier: identifier, source: source.debug, destination: destination.debug) }
    
    public func replicating(using strategy: ReplicationStrategy) -> Shift {
        return Shift(identifier: identifier, source: source.replicating(using: strategy), destination: destination.replicating(using: strategy))
    }
    
    public func visuallyAnimating(using behavior: VisualAnimationBehavior) -> Shift {
        var shift = Shift(identifier: identifier, source: source, destination: destination)
        shift.visualAnimationBehavior = behavior
        return shift
    }
    
    public func visuallyAnimating(using preparations: Shift.VisualAnimationBehavior.Custom.Handler?, animations: @escaping Shift.VisualAnimationBehavior.Custom.Handler) -> Shift {
        return visuallyAnimating(using: .custom(VisualAnimationBehavior.Custom(preparations: preparations, animations: animations)))
    }
    
    public func restoringNativeViews(using behavior: NativeViewRestorationBehavior) -> Shift {
        var shift = Shift(identifier: identifier, source: source, destination: destination)
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
    
    func preshift(for replicant: UIView, using snapshot: Snapshot?) {
        visualShiftPreparations(for: replicant, using: snapshot)
    }
    
    func shift(for replicant: UIView, using snapshot: Snapshot?) {
        positionalShift(for: replicant, using: snapshot)
        visualShift(for: replicant, using: snapshot)
    }
}

// MARK: Helper
extension Shift {
    
    func visualShiftPreparations(for replicant: UIView, using snapshot: Snapshot? = nil) {
        let destination = snapshot ?? destinationSnapshot()
        
        switch visualAnimationBehavior {
        case .custom(let custom): custom.prepare(replicant: replicant, with: destination)
        default: break
        }
    }
    
    func visualShift(for replicant: UIView, using snapshot: Snapshot? = nil) {
        let destination = snapshot ?? destinationSnapshot()
        
        switch visualAnimationBehavior {
        case .none: break
        case .automatic: destination.applyVisualState(to: replicant)
        case .custom(let custom): custom.animate(replicant: replicant, to: destination)
        }
        
        //Execute any alongside animations necessary when shifting from the source to the destination
        source.alongsideAnimations?(replicant, self.destination, destination)
    }
    
    func positionalShift(for replicant: UIView, using snapshot: Snapshot? = nil) {
        (snapshot ?? destinationSnapshot()).applyPositionalState(to: replicant)
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
        hasher.combine(identifier)
        hasher.combine(source)
        hasher.combine(destination)
    }
    
    public static func == (lhs: Shift, rhs: Shift) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.source == rhs.source && lhs.destination == rhs.destination
    }
}
