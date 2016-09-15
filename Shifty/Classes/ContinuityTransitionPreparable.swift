//
//  ContinuityTransitionPreparable.swift
//  Shifty
//
//  Created by William McGinty on 9/10/16.
//
//

import Foundation

//MARK: ContinuityTransitionPreparable Protocol Declaration

/** An object that is capable of performing preparations and cleanup for a 'Continuity' transition.
 */
public protocol ContinuityTransitionPreparable: ContinuityTransitionable {
    
    /// The opportunity for the destination to prepare itself for an incoming transition. Called after the view is loaded and laid out, but before it is visible to the user. For instance, if an object wants to animate it's content into place, it could use this function to move it's content into position so it can animated on screen.
    ///
    /// - parameter source: The view controller being transitioned from.
    func prepareForTransition(from source: UIViewController)
    
    
    /// The opportunity for the source to clean itself up after an outgoing transition. Called after the view has been hidden from the user. For instance, the object could use this function to reset it's state to before the exit animations in the case that object must display it's content again.
    ///
    /// - parameter destination: The view controller being transitioned to.
    func completeTransition(to destination: UIViewController)
}

//MARK: Default UIViewController Extension for ContinuityTransitionPreparable
extension ContinuityTransitionPreparable {
    
    public func prepareForTransition(from source: UIViewController) { /* No op */ }
    public func completeTransition(to destination: UIViewController) { /* No op */ }
}
