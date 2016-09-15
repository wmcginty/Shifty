//
//  ShiftAction.swift
//  Shifty
//
//  Created by William McGinty on 9/13/16.
//
//

import Foundation

struct ShiftAction: FrameShiftAnimatable {
    
    private(set) var animations: Animation
    private(set) var completion: AnimationCompletion?
    
    init(animations: @escaping Animation, completion: AnimationCompletion? = nil) {
        self.animations = animations
        self.completion = completion
    }
    
    func performShift(withDuration duration: TimeInterval, completion block: AnimationCompletion? = nil) {
        let handler = block.map { Combiner.add($0, to: completion) } ?? completion
        UIView.animateShift(withDuration: duration, animations: animations ?? { }, completion: handler)
    }
}
