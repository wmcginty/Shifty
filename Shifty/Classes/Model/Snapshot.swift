//
//  Snapshot.swift
//  Shifty
//
//  Created by William McGinty on 6/3/16.
//  Copyright © 2016 will.mcginty. All rights reserved.
//

import Foundation

/// Represents the positional state of a `UIView` object at any given moment.
public struct Snapshot {
    
    // MARK: Properties
    
    /// The center of `view`.
    let center: CGPoint
    
    /// The bounds of `view`.
    let bounds: CGRect
    
    /// The transform of `view`.
    let transform: CGAffineTransform
    
    /// The transform3d of `view.layer`.
    let transform3d: CATransform3D
    
    // MARK: Initializers
    init(view: UIView) {
        center = view.center
        bounds = view.bounds
        transform = view.transform
        transform3d = view.layer.transform
    }

    /// The center of the Snapshot's `view` with respect to the provided container.
    ///
    /// - parameter view:          The view whose center needs to be converted.
    /// - parameter container: The coordinate space to convert the center into.
    ///
    /// - returns: The center of `view` in the coordinate space of `container`.
    public func center(of view: UIView, withRespectTo container: UIView) -> CGPoint {
        return container.convert(center, from: view.superview)
    }
    
    /// Apply the position state of Snapshot to the provided view in the container.
    ///
    /// - parameter new:       The view to apply the Snapshot too.
    /// - parameter container: The superview of `new`.
    public func applyPositionalState(to new: UIView, in container: UIView) {
        new.bounds = bounds
        new.center = center(of: new, withRespectTo: container)
        new.transform = transform
        new.layer.transform = transform3d
    }
}
