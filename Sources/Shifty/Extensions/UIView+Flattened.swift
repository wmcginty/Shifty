//
//  UIViewController+Flattened.swift
//  Shifty-iOS
//
//  Created by William McGinty on 9/4/19.
//  Copyright © 2019 Will McGinty. All rights reserved.
//

import UIKit

extension UIView {
    
    func flattenedHierarchy(withExclusions exclusions: [UIView], excluder: ((UIView) -> Bool)? = nil) -> [UIView] {
        guard !exclusions.contains(self) else { return [] }
        
        if let excluder = excluder, excluder(self) {
            return []
        }
        
        return [self] + subviews.flatMap { $0.flattenedHierarchy(withExclusions: exclusions, excluder: excluder) }
    }
}
