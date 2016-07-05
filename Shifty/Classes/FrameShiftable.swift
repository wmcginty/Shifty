//
//  FrameShiftable.swift
//  ShiftKit
//
//  Created by Will McGinty on 4/27/16.
//  Copyright © 2016 will.mcginty. All rights reserved.
//

import UIKit

//MARK: FrameShiftable Protocol Declaration
public protocol FrameShiftable {
    
    var viewController: UIViewController { get }
    func shiftablesForTransitionWith(_ viewController: UIViewController) -> [Shiftable]
}

//MARK: CustomFrameShiftable Protocol Declaration
public protocol CustomFrameShiftable: FrameShiftable {
    
    func performShiftWith(_ view: UIView,
                          in containerView: UIView,
                          with finalState: Snapshot,
                          duration: TimeInterval?,
                          completion: () -> Void)
}

//MARK: Extensions
public extension FrameShiftable where Self: UIViewController {
    var viewController: UIViewController { return self }
}
