//
//  Action.swift
//  Shifty
//
//  Created by William McGinty on 1/6/18.
//

import UIKit

public struct Action {
    
    public let handler: (UIView) -> Void
    
    public init(handler: @escaping (UIView) -> Void) {
        self.handler = handler
    }
}

extension Action {
    public static let fadeOut = Action { view in
        view.alpha = 0
    }
    
    public static let scaleDown = Action { view in
        view.transform = view.transform.concatenating(CGAffineTransform(scaleX: 0.01, y: 0.01))
    }
    
    public static let rotate = Action { view in
        view.transform = view.transform.concatenating(CGAffineTransform(rotationAngle: .pi / 2))
    }
}
