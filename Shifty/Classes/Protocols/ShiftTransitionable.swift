//
//  ShiftTransitionable.swift
//  Shifty
//
//  Created by William McGinty on 12/25/17.
//

import UIKit

public protocol ShiftTransitionable {
    
    /// The view that acts as a superview for all other shift-eligible views.
    var shiftContentView: UIView { get }
    
    /// Denotes whether or not the conforming object contains any shiftables.
    var containsStates: Bool { get }
    
    /// A list of views that should be excluded from shifting. These views, and their subviews, will be excluded from shiftable evaluation.
    var shiftExclusions: [UIView] { get }
}

public extension ShiftTransitionable {
    var containsStates: Bool { return true }
    var shiftExclusions: [UIView] { return [] }
}

public extension ShiftTransitionable where Self: UIViewController {
    var shiftContentView: UIView { return view }
}
