//
//  Snapshot.swift
//  Shifty
//
//  Created by William McGinty on 6/3/16.
//  Copyright © 2016 will.mcginty. All rights reserved.
//

import Foundation

/// Represents the positional state of a `UIView` object at any given moment.
public struct Snapshot: Equatable {
    
    // MARK: Properties
    
    /// The center of `view`.
    let center: CGPoint
    
    /// The bounds of `view`.
    let bounds: CGRect
    
    /// The transform3d of `view.layer`.
    let transform: CATransform3D
    
    /// The corner radius of `view.layer`.
    let cornerRadius: CGFloat
    
    // MARK: Initializers
    public init(center: CGPoint, bounds: CGRect, transform: CATransform3D, cornerRadius: CGFloat) {
        self.center = center
        self.bounds = bounds
        self.transform = transform
        self.cornerRadius = cornerRadius
    }
    
    public init(view: UIView) {
        self.init(center: view.center, bounds: view.bounds, transform: view.layer.transform, cornerRadius: view.layer.cornerRadius)
    }
    
    /// The center of the Snapshot's `view` with respect to the provided container.
    ///
    /// - parameter view:          The view whose center needs to be converted.
    /// - parameter container: The coordinate space to convert the center into.
    ///
    /// - returns: The center of `view` in the coordinate space of `container`.
    public func center(of view: UIView, in container: UIView, withReferenceTo referenceView: UIView) -> CGPoint {
        return container.convert(center, from: referenceView)
    }
    
    /// Apply the position state of Snapshot to the provided view in the container.
    ///
    /// - parameter new:       The view to apply the Snapshot too.
    /// - parameter container: The superview of `new`.
    public func applyState(to new: UIView, in container: UIView, withReferenceTo view: UIView) {
        new.bounds = bounds
        new.center = center(of: new, in: container, withReferenceTo: view)
        
        /*Setting the view.transform simply converts the affine transform to into a 3D coordinate space and sets the layer's CATransform3D.
         This means we shouldn't (can't) animate both properties simultaneously - and instead rely solely on the view's layer's CATransform3D. */
        new.layer.transform = transform
        new.layer.cornerRadius = cornerRadius
    }
}

// MARK: CATransform3D Conformation To Equatable
extension CATransform3D: Equatable {
    public static func == (lhs: CATransform3D, rhs: CATransform3D) -> Bool {
        return CATransform3DEqualToTransform(lhs, rhs)
    }
}
