//
//  Action.swift
//  Shifty
//
//  Created by William McGinty on 1/6/18.
//

import UIKit

public struct Action {
    
    public let handler: (UIView, TimeInterval) -> Void
    
    public init(handler: @escaping (UIView, TimeInterval) -> Void) {
        self.handler = handler
    }
}

extension Action {
    public static let fadeOut = Action { view, duration in
        UIView.animate(withDuration: duration, animations: {
            view.alpha = 0
        })
    }
    
    public static let scaleDown = Action { view, duration in
        UIView.animate(withDuration: duration, animations: {
            view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        })
    }
}
