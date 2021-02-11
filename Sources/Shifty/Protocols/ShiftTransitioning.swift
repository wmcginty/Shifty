//
//  ShiftTransitioning.swift
//  Shifty
//
//  Created by William McGinty on 12/25/17.
//

import UIKit

public protocol ShiftTransitioning {
    
    /// The view that acts as a superview for all other shift-eligible views.
    var contentView: UIView { get }
    
    /// Denotes whether or not the conforming object contains any shift-eligible objects.
    var isShiftingEnabled: Bool { get }
    
    /// A list of views that should be excluded from shifting. These views, and their subviews, will be excluded from shift-eligible evaluation.
    var shiftExclusions: [UIView] { get }
    
    /// A closure that is evaluated on each potential shifting view. If this closure returns true, the view will not be eligible for shifting.
    var shiftExcluder: (UIView) -> Bool { get }
}

public extension ShiftTransitioning {
    
    /// Provides a default value of 'true' to all conformers.
    var isShiftingEnabled: Bool { return true }
    
    /// Provides a default value of an empty array to all conformers.
    var shiftExclusions: [UIView] { return [] }
    
    var shiftExcluder: (UIView) -> Bool { return { _ in false } }
}

public extension ShiftTransitioning where Self: UIViewController {
    
    /// Provides a default value of .view to all conforming UIViewControllers.
    var contentView: UIView { return view }
}
