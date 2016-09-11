//
//  Shiftable.swift
//  Shifty
//
//  Created by Will McGinty on 5/2/16.
//  Copyright © 2016 will.mcginty. All rights reserved.
//

import UIKit

//MARK: ShiftState Struct

/// Represents a single state of a shifting `UIView`.
public struct Shiftable {
    
    public typealias ShiftingViewConfigurator = (_ shiftable: Shiftable, _ forView: UIView, _ containerView: UIView) -> UIView
    
    //MARK: Properties
    
    /// The view being subjected to the shift.
    public let view: UIView
    
    /// The direct superview of `view`.
    public let superview: UIView
    
    /// The identifier assigned to this `Shiftable`. Each identifier in the source, should match an identifier in the destination.
    public let identifier: AnyHashable
    
    /// The closure used to configure the view. This is optional and only required if a snapshot is insufficient.
    public var shiftingViewConfigurator : ShiftingViewConfigurator?
    
    //MARK: Initializers    
    public init(view: UIView, identifier: AnyHashable, configurator: ShiftingViewConfigurator? = nil) {
        guard let superview = view.superview else { fatalError("The view being shifted must have a superview.") }
        self.init(view: view, inSuperview: superview, identifier: identifier, configurator: configurator)
    }
    
    public init(view: UIView, inSuperview superview: UIView, identifier: AnyHashable, configurator: ShiftingViewConfigurator? = nil) {
        self.view = view
        self.superview = superview
        self.identifier = identifier
        self.shiftingViewConfigurator = configurator
    }
}

//MARK: Internal Interface
extension Shiftable {
    
    /// Returns a `Snapshot` of the current state of the `Shiftable`.
    func snapshot() -> Snapshot {
        return Snapshot(view: view)
    }
}

//MARK: Public Interface
public extension Shiftable {
    
    /**
     Creates a shifting view by duplicating (or recreating) the `Shiftables view`. If `shiftingViewConfigurator` is not `nil` - it will be used to create the shifting view. Otherwise, a snapshot of the view will be used. Note: If neither methods can be used to create a `UIView`, a fatal error will be thrown.
     
    - parameter containerView: The container which should house the shiftingView.
    */
    func viewForShiftWithRespect(to containerView: UIView) -> UIView {
        
        guard !ProcessInfo.processInfo.arguments.contains("-shifty_snapshot_debug") else {
            let view = UIView()
            view.backgroundColor = .red
            applyPositionalState(to: view, in: containerView)
            return view
        }
        
        guard let snapshotView = shiftingViewConfigurator?(self, view, containerView) ?? view.snapshotView(afterScreenUpdates: false) else {
            fatalError("Unable to create a view for the frame shift for Shiftable: \(self)")
        }
    
        applyPositionalState(to: snapshotView, in: containerView)
        return snapshotView
    }
    
    /**
     A wrapper around `Snapshot`s function applyPositionalState(_:in:). Uses a `Snapshot` of the current state.
     
     - parameter newView: The view to apply the Snapshot too.
     - parameter containerView: The superview of `newView`.
    */
    func applyPositionalState(to newView: UIView, in containerView: UIView) {
        
        let currentSnapshot = snapshot()
        currentSnapshot.applyPositionalState(to: newView, in: containerView)
    }
}

//MARK: Hashable
extension Shiftable: Hashable {
    
    public var hashValue: Int {
        return identifier.hashValue
    }
}

//MARK: Equatable
public func ==(lhs: Shiftable, rhs: Shiftable) -> Bool {
    return lhs.identifier == rhs.identifier
}
