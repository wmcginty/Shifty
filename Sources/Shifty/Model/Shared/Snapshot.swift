//
//  Snapshot.swift
//  Shifty
//
//  Created by William McGinty on 6/3/16.
//  Copyright © 2016 will.mcginty. All rights reserved.
//

import Foundation

/// Represents the state of a `UIView` object at any given moment in time.
public struct Snapshot: Equatable {
    
    // MARK: Properties
    
    /// The center of the `UIView` at the time of snapshotting.
    let center: CGPoint
    
    /// The bounds of the `UIView` at the time of snapshotting.
    let bounds: CGRect
    
    /// The alpha of the `UIView` at the time of snapshotting.
    let alpha: CGFloat
    
    /// The backgroundColor of the `UIView` at the time of snapshotting.
    let backgroundColor: UIColor?
    
    /// The transform3d of the view's `CALayer` at the time of snapshotting. This property also includes any changes made to the `UIView.transform` property, as they are converted from an affine transform into a 3-dimensional `CATransform3D` when set on the view.
    let transform3D: CATransform3D
    
    /// The corner radius of the view's `CALayer` at the time of snapshotting.
    let cornerRadius: CGFloat
    
    /// The superview to which all positional properties are relative.
    let superview: UIView?
    
    // MARK: Initializers
    init(center: CGPoint, bounds: CGRect, alpha: CGFloat, backgroundColor: UIColor? = nil, transform3D: CATransform3D, cornerRadius: CGFloat, superview: UIView?) {
        self.center = center
        self.bounds = bounds
        self.alpha = alpha
        self.backgroundColor = backgroundColor
        self.transform3D = transform3D
        self.cornerRadius = cornerRadius
        self.superview = superview
    }
    
    public init(view: UIView) {
        self.init(center: view.center, bounds: view.bounds, alpha: view.alpha, backgroundColor: view.backgroundColor,
                  transform3D: view.layer.transform, cornerRadius: view.layer.cornerRadius, superview: view.superview)
    }
    
    // MARK: Interface
    
    /// The center of the `Snapshot` with respect to the provided container.
    ///
    /// - parameter container: The view to convert the center into.
    ///
    /// - returns: The center of `view` in the coordinate space of `container`.
    public func center(in container: UIView) -> CGPoint {
        #if DEBUG
        if superview == nil {
            debugPrint("Shifty Warning: The snapshot was not able to capture a superview- this may cause positional miscalculations related to the snapshotted view.")
        }
        #endif
        
        return container.convert(center, from: superview)
    }
    
    /// Apply the positional state of Snapshot to the provided view in the container.
    ///
    /// - Parameters:
    ///   - new: The view to apply the Snapshot too.
    ///   - container: The direct superview of `new`.
    public func applyPositionalState(to new: UIView) {
        new.bounds = bounds
        new.superview.map { new.center = center(in: $0) }
        new.layer.transform = transform3D
    }
    
    /// Apply the visual state of Snapshot to the provided view in the container.
    ///
    /// - Parameters:
    ///   - new: The view to apply the Snapshot too.
    public func applyVisualState(to new: UIView) {
        new.alpha = alpha
        new.backgroundColor = backgroundColor
        new.layer.cornerRadius = cornerRadius
    }
}
