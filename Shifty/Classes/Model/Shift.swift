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
    public let animationContext: AnimationContext
    
    // MARK: Initializers
    public init(source: State, destination: State, animationContext: AnimationContext = CubicAnimationContext.default) {
        self.source = source
        self.destination = destination
        self.animationContext = animationContext
    }
    
    // MARK: Hashable
    public var hashValue: Int {
        return source.hashValue ^ destination.hashValue
    }
    
    public static func == (lhs: Shift, rhs: Shift) -> Bool {
        return lhs.source == rhs.source && lhs.destination == rhs.destination
    }
}

// MARK: Container Management
extension Shift {
    
    func configuredShiftingView(in container: UIView) -> UIView {
        
        //Create, add and place the shiftingView with respect to the container
        let shiftingView = source.viewForShiftWithRespect(to: container)
        container.addSubview(shiftingView)
        source.applyState(to: shiftingView, in: container)
        
        //Configure the native views as hidden so the shiftingView is the only visible copy, then return it
        configureNativeViews(hidden: true)
        return shiftingView
    }
    
    func shiftAnimations(for shiftingView: UIView, in container: UIView, target: Snapshot?) {
        animationContext.performAnimations {
            target?.applyState(to: shiftingView, in: container)
        }
    }
    
    func cleanupShiftingView(_ shiftingView: UIView) {
        configureNativeViews(hidden: false)
        shiftingView.removeFromSuperview()
    }
}

// MARK: Snapshots
extension Shift {
    
    func destinationSnapshot() -> Snapshot {
        return destination.currentSnapshot()
    }
    
    func configureNativeViews(hidden: Bool) {
        [source, destination].forEach { $0.configureNativeView(hidden: hidden) }
    }
}
