//
//  FrameShift.swift
//  ShiftKit
//
//  Created by William McGinty on 6/7/16.
//  Copyright © 2016 will.mcginty. All rights reserved.
//

import Foundation

struct FrameShift {
    
    //MARK: Properties
    let initial: Shiftable
    let final: Shiftable
    
    //MARK: Initializers
    init(initialState: Shiftable, finalState: Shiftable) {
        initial = initialState
        final = finalState
        
        assert(initialState.identifier == finalState.identifier, "Initial and Final identifiers must match.")
    }
}
