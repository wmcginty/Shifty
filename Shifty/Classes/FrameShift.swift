//
//  FrameShift.swift
//  ShiftKit
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
