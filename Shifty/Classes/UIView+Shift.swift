//
//  UIView+Shift.swift
//  Shifty
//
//  Created by William McGinty on 9/13/16.
//
//

import UIKit

extension UIView {
    
    static func animateShift(withDuration duration: TimeInterval, animations: @escaping Animation, completion: AnimationCompletion?) {
        UIView.animate(withDuration: duration, delay: 0.0, options: [.beginFromCurrentState], animations: animations, completion: completion)
    }
}
