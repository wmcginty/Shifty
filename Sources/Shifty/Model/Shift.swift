//
//  Shift.swift
//  Shifty
//
//  Created by William McGinty on 12/25/17.
//

import Foundation

/// Represents the frame shift of a single `UIView` object.
public struct Shift: Hashable {
    
    // MARK: Properties
    public let source: State
    public let destination: State
    public let timingContext: TimingContext
    
    // MARK: Initializers
    public init(source: State, destination: State, timingContext: TimingContext = CubicAnimationContext.default) {
        self.source = source
        self.destination = destination
        self.timingContext = timingContext
    }
    
    // MARK: Hashable
    public var hashValue: Int {
        return source.hashValue ^ destination.hashValue
    }
    
    // MARK: Equatable
    public static func == (lhs: Shift, rhs: Shift) -> Bool {
        return lhs.source == rhs.source && lhs.destination == rhs.destination
    }
}

// MARK: Container Management
extension Shift {
    
    func configuredShiftingView(inContainer container: UIView) -> UIView {
        //Create, add and place the shiftingView with respect to the container
        let shiftingView = source.configuredReplicantView(inContainer: container, afterScreenUpdates: true)
        configureNativeViews(hidden: true)
        
        return shiftingView
    }
    
    func shiftAnimations(for shiftingView: UIView, in container: UIView, target: Snapshot?) {
        if let destinationSuperview = destination.view.superview {
            timingContext.animate {
                target?.applyState(to: shiftingView, in: container, withReferenceTo: destinationSuperview)
            }
        }
    }
    
    func cleanupShiftingView(_ shiftingView: UIView) {
        [source, destination].forEach { $0.cleanupReplicantView(shiftingView) }
    }
}

// MARK: Snapshots
extension Shift {
    
    func destinationSnapshot() -> Snapshot {
        return destination.snapshot()
    }
    
    func configureNativeViews(hidden: Bool) {
        [source, destination].forEach { $0.configureNativeView(hidden: hidden) }
    }
}
