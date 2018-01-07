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
        UIView.animate(withDuration: 1.5, animations: {
            view.alpha = 0
        })
    }
}
