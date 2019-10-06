//
//  TransitionDriving.swift
//  Shifty
//
//  Created by William McGinty on 12/25/17.
//

import Foundation

public typealias ShiftTransitionDriving = TransitionDriving & ShiftTransitioning

public protocol TransitionDriving {
    func prepareForTransition(to destination: TransitionDriving?, withDuration duration: TimeInterval, completion: @escaping (Bool) -> Void)
    func completeTransition(to destination: TransitionDriving?)
    
    func prepareForTransition(from source: TransitionDriving?)
    func completeTransition(from source: TransitionDriving?)
}

public extension TransitionDriving {
    func completeTransition(to destination: TransitionDriving?) { /* No op */ }
    func prepareForTransition(from source: TransitionDriving?) { /* No op */ }
}
