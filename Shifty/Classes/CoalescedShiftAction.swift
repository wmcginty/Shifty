//
//  CoalescedShiftAction.swift
//  Shifty
//
//  Created by William McGinty on 9/13/16.
//
//

import Foundation

class CoalescedShiftAction: Coalesced<ShiftAction>, FrameShiftAnimatable {
    
    func performShift(withDuration duration: TimeInterval, completion: AnimationCompletion? = nil) {
        
        for (index, shiftAnimatable) in objects.enumerated() {
            let completion = index == objects.endIndex - 1 ? completion : nil
            shiftAnimatable.performShift(withDuration: duration, completion: completion)
        }
    }
}
