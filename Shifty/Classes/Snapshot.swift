//
//  Snapshot.swift
//  ShiftKit
//
//  Created by William McGinty on 6/3/16.
//  Copyright © 2016 will.mcginty. All rights reserved.
//

import Foundation

/// Represents the positional state of a `UIView` object at any given moment.
public struct Snapshot {
    
    /// The center of `view`.
    let center: CGPoint
    
    /// The bounds of `view`.
    let bounds: CGRect
    
    /// The transform of `view`.
    let transform: CGAffineTransform
    
    /// The transform3d of `view.layer`.
    let transform3d: CATransform3D
    
    init(view: UIView) {
        center = view.center
        bounds = view.bounds
        transform = view.transform
        transform3d = view.layer.transform
    }
    
    /**
     The center of the Snapshot's `view` with respect to the provided container.
     
     - parameter view: The view whose center needs to be converted.
     - parameter containerView: The coordinate space to convert the center into.
     
     - returns: The center of `view` in the coordinate space of `containerView`.
     */
    func centerOf(_ view: UIView, withRespectTo containerView: UIView) -> CGPoint {
        return containerView.convert(center, from: view.superview)
    }
    
    /**
     Apply the position state of Snapshot to the provided view in the container.
     
     - parameter newView: The view to apply the Snapshot too.
     - parameter containerView: The superview of `newView`.
     */
    func applyPositionalStateTo(_ newView: UIView, in containerView: UIView) {
        newView.bounds = bounds
        newView.center = centerOf(newView, withRespectTo: containerView)
        newView.transform = transform
        newView.layer.transform = transform3d
    }
}
