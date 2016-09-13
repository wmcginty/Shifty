//
//  FrameShift.swift
//  Shifty
//
//  Created by William McGinty on 6/7/16.
//  Copyright © 2016 will.mcginty. All rights reserved.
//

import Foundation

/// Represents the frame shift of a single `UIView` object.
struct FrameShift {
    
    //MARK: Properties
    
    /// The initial state of the shift.
    let initial: Shiftable
    
    /// The final state of the shift
    let final: Shiftable
    
    //MARK: Initializers
    init(initialState: Shiftable, finalState: Shiftable) {
        initial = initialState
        final = finalState
        
        assert(initialState.identifier == finalState.identifier, "Initial and Final identifiers must match.")
    }
}

extension FrameShift {
    
    typealias Shift = () -> Void
    
    /// Creates a default shift from self, and applies it to the given view residing in the container.
    ///
    /// - parameter shiftingView:  The view which will be shifted according to the initial and final states of self.
    /// - parameter containerView: The container view acting as the superview of the shiftingView
    /// - parameter snapshot:      The snapshot of the final state to use, if none is provided one will be created.
    func shiftApplied(to shiftingView: UIView, in containerView: UIView, withFinal snapshot: Snapshot? = nil) -> Shift {
        
        let finalSnapshot = snapshot ?? final.snapshot()
        return { finalSnapshot.applyPositionalState(to: shiftingView, in: containerView) }
    }
}

extension FrameShift: Equatable {
    static func ==(lhs: FrameShift, rhs: FrameShift) -> Bool {
        return true
    }
}
