//
//  FrameShiftable.swift
//  Shifty
//
//  Created by Will McGinty on 4/27/16.
//  Copyright © 2016 will.mcginty. All rights reserved.
//

import UIKit

//MARK: FrameShiftable Protocol Declaration

/**
 An object that is capable of frame-shifting a subset of it's view hierarchy during a transition.
 */
public protocol FrameShiftable {
    
    ///The viewController associated with this object - defaults to `self` when conforming as a `UIViewController`.
    var viewController: UIViewController { get }
    
    /**
     The subset of the view hierarchy designed to frame shift to a specific destination. These views must be wrapped into a `Shiftable`.
     
     - parameter viewController: The view controller being transitioned to.
     - returns: An array of `Shiftable`s that designates the views eligible for frame shifting.
    */
    func shiftablesForTransition(with viewController: UIViewController) -> [Shiftable]
}

//MARK: CustomFrameShiftable Protocol Declaration

/**
 An object capable of provided a custom shift transition, given the context of this animation.
 */
public protocol CustomFrameShiftable: FrameShiftable {
    
    /**
     The animations desired in order to fulfill the requirements of the shift. Given the context of the shift and `completion`, these animations should finish the shift - not adhering to the duration or final state provided will result in visual glitches in the transition.
     
     - parameter shiftingView: The view that is being shifted. A subview of `containerView`.
     - parameter containerView: The container of the transition. The source, destination and `shiftingView` are all subviews.
     - parameter finalState: The final positional state of the shiftingView. Can include `center`, `position`, `transform` and `layer.transform3d`.
     - parameter duration: Optional duration of the transition. If nil, any duration can be used.
     - parameter completion: The closure to be executed at the end of the custom shifting animation.
     */
    func performShift(with shiftingView: UIView, in containerView: UIView, with finalState: Snapshot, duration: TimeInterval?, completion: () -> Void)
}

//MARK: Extensions
public extension FrameShiftable where Self: UIViewController {
    var viewController: UIViewController { return self }
}
