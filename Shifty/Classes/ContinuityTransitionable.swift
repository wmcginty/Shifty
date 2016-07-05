//
//  ContinuityTransitionable.swift
//  ShiftKit
//
//  Created by Will McGinty on 4/27/16.
//  Copyright © 2016 will.mcginty. All rights reserved.
//

import UIKit

//MARK: ContinuityTransitionable Protocol Declaration

/** An object that is capable of performing a 'Continuity' transition.
 
 At it's most basic a continuity transition follows a baic prcoess. First, the transition will briefly allow the source to prepare for the transition. When the source has completed it's preparations, the transition will swap out the view controllers and allow the destination the opportunity to complete the transition.
 */
public protocol ContinuityTransitionable {
    
    /**
     The opportunity for the object (as the source) to perform any actions that need to be done before the transition proceeds. For instance, this method can be used to perform exiting animations for a view controller's content.
     
     - parameter destination: The view controller being transitioned to.
     - parameter duration: The duration of the transition alloted to the preparation. Not obeying this duration can lead to visual glitches.
     - parameter completion: The closure to be executed at the end of the preparations. Failure to execute this closure will break the transition.
    */
    func prepareForTransitionTo(_ destination: UIViewController, with duration: TimeInterval, completion: (Bool) -> Void)
    
    /**
    The opportunity for the object (as the destination) to perform any actions that need to be done to complete a transition. For instance, this method can be used to perform entrance animations on a view controller's content.
 
    - parameter source: The view controller being transitioned from.
    */
    func completeTransitionFrom(_ source: UIViewController)
}

//MARK: ContinuityTransitionPreparable Protocol Declaration

/** An object that is capable of performing preparations and cleanup for a 'Continuity' transition.
 */
public protocol ContinuityTransitionPreparable: ContinuityTransitionable {
    /**
     The opportunity for the destination to prepare itself for an incoming transition. Called after the view is loaded and laid out, but before it is visible to the user. For instance, if an object wants to animate it's content into place, it could use this function to move it's content into position so it can animated on screen.
     
     - parameter source: The view controller being transitioned from.
     */
    func prepareForTransitionFrom(_ source: UIViewController)
    
    /**
     The opportunity for the source to clean itself up after an outgoing transition. Called after the view has been hidden from the user. For instance, the object could use this function to reset it's state to before the exit animations in the case that object must display it's content again.
     
     - parameter destination: The view controller being transitioned to.
     */
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

