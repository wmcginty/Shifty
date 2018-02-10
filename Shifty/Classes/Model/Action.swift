//
//  Action.swift
//  Shifty
//
//  Created by William McGinty on 1/6/18.
//

import UIKit

public struct Action {
    
    //MARK: Properties
    public let handler: (UIView) -> Void
    
    //MARK: Initializers
    public init(handler: @escaping (UIView) -> Void) {
        self.handler = handler
    }
}

//MARK: Presets
extension Action {
    
    public static func fade(to alpha: CGFloat) -> Action {
        return Action { view in
            view.alpha = alpha
        }
    }
    
    public static func transform(to transform: CGAffineTransform) -> Action {
        return Action { view in
            view.transform = view.transform.concatenating(transform)
        }
    }
    
    public static func scale(toX x: CGFloat, y: CGFloat) -> Action {
        return transform(to: CGAffineTransform(scaleX: x, y: y))
    }
    
    public static func rotate(to angle: CGFloat) -> Action {
        return transform(to: CGAffineTransform(rotationAngle: angle))
    }
    
    public static func translate(byX x: CGFloat, y: CGFloat) -> Action {
        return transform(to: CGAffineTransform(translationX: x, y: y))
    }
}
