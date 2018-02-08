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
    
    init(view: UIView) {
        self.init(center: view.center, bounds: view.bounds, transform: view.layer.transform, cornerRadius: view.layer.cornerRadius)
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
    public func applyState(to new: UIView, in container: UIView) {
        new.bounds = bounds
        new.center = center(of: new, withRespectTo: container)
        
        /*Setting the view.transform converts the affine transform to a 3d space and sets the layer's transform.
            This means we can safely 'ignore' it, and instead rely soly on the 3d transform of the view's layer. */
        new.layer.transform = transform
        new.layer.cornerRadius = cornerRadius
    }
}

// MARK: Equatable
extension Snapshot: Equatable {
    
    public static func == (lhs: Snapshot, rhs: Snapshot) -> Bool {
        return lhs.bounds == rhs.bounds && lhs.center == rhs.center && lhs.transform == rhs.transform && lhs.cornerRadius == rhs.cornerRadius
    }
}

extension CATransform3D: Equatable {
    public static func == (lhs: CATransform3D, rhs: CATransform3D) -> Bool {
        return CATransform3DEqualToTransform(lhs, rhs)
    }
}
