//
//  UIView+Background.swift
//  Shifty
//
//  Created by William McGinty on 9/12/16.
//
//

import Foundation

extension UIView {
    
    /// Creates a UIView with the given background color
    ///
    /// - parameter backgroundColor: The color to set as the background for the view
    ///
    /// - returns: A UIView instantiate with a frame of .zero and the given background color
    convenience init(backgroundColor: UIColor) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }
}
