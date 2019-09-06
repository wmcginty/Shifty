//
//  ActionLocating.swift
//  Shifty-iOS
//
//  Created by William McGinty on 9/2/19.
//  Copyright © 2019 Will McGinty. All rights reserved.
//

import Foundation

public protocol ActionLocating {
    
    /// Searches the view hierarchy of a given source to find possible `Action` objects.
    ///
    /// - Parameter view: The source content view whose subview will be searched for `Action`s.
    /// - Returns: An array of `Action` objects suitable for animation with an `ActionAnimator`.
    func actions(in view: UIView) -> [Action]
}

public struct ActionLocator: ActionLocating {
    
    public init() { }
    
    public func actions(in view: UIView) -> [Action] {
        return view.flattenedHierarchy(withExclusions: []).compactMap { $0.action }
    }
}
