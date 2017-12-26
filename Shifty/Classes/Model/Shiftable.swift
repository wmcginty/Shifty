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
    
    public enum Configuration {
        public typealias Configurator = (_ baseView: UIView) -> UIView
        
        case snapshot
        case configured(Configurator)
        
        //MARK: Interface
        func configuredShiftingView(for baseView: UIView) -> UIView {
            switch self {
            case .snapshot:
                guard let snapshot = baseView.snapshotView(afterScreenUpdates: true) else { fatalError("Unable to snapshot view: \(baseView)") }
                return snapshot
                
            case .configured(let configurator):
                return configurator(baseView)
            }
        }
    }
    
    //MARK: Properties
    public let view: UIView /// The view being subjected to the shift.
    public let superview: UIView /// The direct superview of `view`.
    public let identifier: AnyHashable /// The identifier assigned to this `Shiftable`. Each identifier in the source should match an identifier in the destination.
    public let configuration: Configuration /// The method used to configure the view. Defaults to .snapshot.
    
    //MARK: Initializers    
    public init(view: UIView, identifier: AnyHashable, configuration: Configuration = .snapshot) {
        guard let superview = view.superview else { fatalError("In order to shift - the view must have a superview: \(view)") }
        self.init(view: view, inSuperview: superview, identifier: identifier, configuration: configuration)
    }
    
    public init(view: UIView, inSuperview superview: UIView, identifier: AnyHashable, configuration: Configuration = .snapshot) {
        self.view = view
        self.superview = superview
        self.identifier = identifier
        self.configuration = configuration
    }
}

//MARK: Public Interface
public extension Shiftable {
    
    func viewForShiftWithRespect(to container: UIView) -> UIView {
        return configuration.configuredShiftingView(for: view)
    }
    
    func applyPositionalState(to view: UIView, in container: UIView) {
        currentSnapshot().applyPositionalState(to: view, in: container)
    }
}

//MARK: Internal Interface
extension Shiftable {
    
    /// Returns a `Snapshot` of the current state of the `Shiftable`.
    func currentSnapshot() -> Snapshot {
        return Snapshot(view: view)
    }
}

//MARK: Hashable
extension Shiftable: Hashable {
    
    public var hashValue: Int {
        return identifier.hashValue
    }
    
    public static func ==(lhs: Shiftable, rhs: Shiftable) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

