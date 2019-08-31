//
//  ShiftTransitionable.swift
//  Shifty
//
//  Created by William McGinty on 12/25/17.
//

import UIKit

public protocol ShiftTransitionable {
    
    /// The view that acts as a superview for all other shift-eligible views.
    var contentView: UIView { get }
    
    /// Denotes whether or not the conforming object contains any shiftables.
    var isShiftingEnabled: Bool { get }
    
    /// A list of views that should be excluded from shifting. These views, and their subviews, will be excluded from shiftable evaluation.
    var shiftExclusions: [UIView] { get }
}

public extension ShiftTransitionable {
    
    /// Provides a default value of 'true' to all conformers.
    var isShiftingEnabled: Bool { return true }
    
    /// Provides a default value of an empty array to all conformers.
    var shiftExclusions: [UIView] { return [] }
}

public extension ShiftTransitionable where Self: UIViewController {
    
    /// Provides a default value of .view to all conforming UIViewControllers.
    var contentView: UIView { return view }
}
