//
//  FrameShiftAnimatable.swift
//  Shifty
//
//  Created by William McGinty on 9/13/16.
//
//

import Foundation


protocol FrameShiftAnimatable {
        
    func performShift(withDuration duration: TimeInterval, completion: AnimationCompletion?)
}
