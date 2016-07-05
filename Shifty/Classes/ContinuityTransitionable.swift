//
//  ContinuityTransitionable.swift
//  ShiftKit
//
//  Created by Will McGinty on 4/27/16.
//  Copyright © 2016 will.mcginty. All rights reserved.
//

import UIKit

//MARK: ContinuityTransitionable Protocol Declaration
public protocol ContinuityTransitionable {
    
    func prepareForTransitionTo(_ destination: UIViewController, with duration: TimeInterval, completion: (Bool) -> Void)
    func completeTransitionFrom(_ source: UIViewController)
}

//MARK: ContinuityTransitionPreparable Protocol Declaration
public protocol ContinuityTransitionPreparable: ContinuityTransitionable {
    
    func prepareForTransitionFrom(_ source: UIViewController)
    func completeTransitionTo(_ destination: UIViewController)
}

//MARK: Default UIViewController Extension for ContinuityTransitionable
extension ContinuityTransitionable where Self: UIViewController {
    
    func prepareForTransitionTo(_ destination: UIViewController, with duration: TimeInterval, completion: (Bool) -> Void) {
        completion(true)
    }
    
    func completeTransitionFrom(_ source: UIViewController) {
        //No op - it is entirely feasible to not have any entrance animations to perform when transitioning from a certain view controller
    }
}

