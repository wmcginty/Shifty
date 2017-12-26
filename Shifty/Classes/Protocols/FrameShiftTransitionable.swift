//
//  FrameShiftCoordinatable.swift
//  Shifty
//
//  Created by William McGinty on 12/25/17.
//

import Foundation

public protocol FrameShiftTransitionable {
    func shiftablesForTransition(with transitionable: FrameShiftTransitionable) -> [Shiftable]
}
