//
//  TransitionRespondable.swift
//  Shifty
//
//  Created by William McGinty on 12/25/17.
//

import Foundation

public protocol TransitionRespondable {
    func prepareForTransition(to destination: TransitionRespondable?, withDuration duration: TimeInterval, completion: @escaping (Bool) -> Void)
    func completeTransition(to destination: TransitionRespondable?)
    
    func prepareForTransition(from source: TransitionRespondable?)
    func completeTransition(from source: TransitionRespondable?)
}

public extension TransitionRespondable {
    func completeTransition(to destination: TransitionRespondable?) { /* No op */ }
    func prepareForTransition(from source: TransitionRespondable?) { /* No op */ }
}

