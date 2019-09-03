//
//  ActionLocator.swift
//  Shifty-iOS
//
//  Created by William McGinty on 9/2/19.
//  Copyright © 2019 Will McGinty. All rights reserved.
//

import Foundation

public struct ActionLocator {
    
    public init() { }
    
    public func actions(in view: UIView) -> [Action] {
        return flattenedHierarchy(for: view, withExclusions: []).compactMap { $0.action }
    }
   
    public func flattenedHierarchy(for view: UIView, withExclusions exclusions: [UIView]) -> [UIView] {
        guard !exclusions.contains(view), !view.isHidden else { return [] }
        return [view] + view.subviews.flatMap { flattenedHierarchy(for: $0, withExclusions: exclusions) }
    }
}
