//
//  Shiftable.swift
//  ShiftKit
//
//  Created by Will McGinty on 5/2/16.
//  Copyright © 2016 will.mcginty. All rights reserved.
//

import UIKit

//MARK: Internal ShiftState Struct
public struct Shiftable {
    
    public typealias ShiftingViewConfigurator = (shiftable: Shiftable, forView: UIView, containerView: UIView) -> UIView
    
    //MARK: Properties
    public let view: UIView
    public let superview: UIView
    public let identifier: String
    
    public var shiftingViewConfigurator : ShiftingViewConfigurator?
    
    //MARK: Initializers
    public init(view: UIView, identifier: String, configurator: ShiftingViewConfigurator? = nil) {
        guard let superview = view.superview else { fatalError("The view being shifted must have a superview.") }
        self.init(view: view, inSuperview: superview, identifier: identifier, configurator: configurator)
    }
    
    public init(view: UIView, inSuperview superview: UIView, identifier: String, configurator: ShiftingViewConfigurator? = nil) {
        self.view = view
        self.superview = superview
        self.identifier = identifier
        self.shiftingViewConfigurator = configurator
    }
}

//MARK: Internal Interface
extension Shiftable {
    
    func snapshot() -> Snapshot {
        return Snapshot(view: view)
    }
}

//MARK: Public Interface
public extension Shiftable {
    
    func viewForShiftWithRespectTo(_ containerView: UIView) -> UIView {
        
        let view = shiftingViewConfigurator?(shiftable: self, forView: self.view, containerView: containerView) ?? self.view.snapshotView(afterScreenUpdates: false)
        guard let shiftView = view else { fatalError("Unable to create a view for the frame shift for Shiftable: \(self)") }
        
        applyPositionalStateTo(shiftView, in: containerView)
        
        return shiftView
    }
    
    func applyPositionalStateTo(_ newView: UIView, in containerView: UIView) {
        
        let currentSnapshot = snapshot()
        currentSnapshot.applyPositionalStateTo(newView, in: containerView)
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
