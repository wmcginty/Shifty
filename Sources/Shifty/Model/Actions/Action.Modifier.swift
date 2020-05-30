//
//  Action.Modifier.swift
//  Shifty-iOS
//
//  Created by William McGinty on 9/2/19.
//  Copyright © 2019 Will McGinty. All rights reserved.
//

import Foundation

public extension Action {
    
    struct Modifier {
        
        // MARK: - Properties
        public let replicationStrategy: ReplicationStrategy
        public let restoreNativewView: Bool
        public let handler: (UIView) -> Void
        
        // MARK: - Initializers
        public init(replicationStrategy: ReplicationStrategy = .snapshot, restoreNativeView: Bool = true, handler: @escaping (UIView) -> Void) {
            self.replicationStrategy = replicationStrategy
            self.restoreNativewView = restoreNativeView
            self.handler = handler
        }
        
        // MARK: - Interface
        public func modify(_ view: UIView) {
            handler(view)
        }
        
        public func configuredShiftingView(for view: UIView) -> UIView {
            return replicationStrategy.configuredShiftingView(for: view, afterScreenUpdates: true)
        }
        
        // MARK: - Concatenation
        public func concatenating(_ modifier: Modifier) -> Modifier {
            return Modifier(replicationStrategy: replicationStrategy) { view in
                self.modify(view)
                modifier.modify(view)
            }
        }
    }
}

// MARK: - Convenience
public extension Action.Modifier {
    
    func fade(to alpha: CGFloat) -> Action.Modifier {
        return concatenating(Action.Modifier { $0.alpha = alpha })
    }
    
    func transform(concatenating transform: CGAffineTransform) -> Action.Modifier {
        return concatenating(Action.Modifier { $0.transform = $0.transform.concatenating(transform) })
    }
    
    func scale(toX x: CGFloat, y: CGFloat) -> Action.Modifier {
        return concatenating(transform(concatenating: CGAffineTransform(scaleX: x, y: y)))
    }
    
    func rotate(to angle: CGFloat) -> Action.Modifier {
        return concatenating(transform(concatenating: CGAffineTransform(rotationAngle: angle)))
    }
    
    func translate(byX x: CGFloat, y: CGFloat) -> Action.Modifier {
        return concatenating(transform(concatenating: CGAffineTransform(translationX: x, y: y)))
    }
}

// MARK: - Presets
public extension Action.Modifier {
    
    static func fade(to alpha: CGFloat) -> Action.Modifier {
        return Action.Modifier { $0.alpha = alpha }
    }
    
    static func transform(concatenating transform: CGAffineTransform) -> Action.Modifier {
        return Action.Modifier { $0.transform = $0.transform.concatenating(transform) }
    }
    
    static func scale(toX x: CGFloat, y: CGFloat) -> Action.Modifier {
        return transform(concatenating: CGAffineTransform(scaleX: x, y: y))
    }
    
    static func rotate(to angle: CGFloat) -> Action.Modifier {
        return transform(concatenating: CGAffineTransform(rotationAngle: angle))
    }
    
    static func translate(byX x: CGFloat, y: CGFloat) -> Action.Modifier {
        return transform(concatenating: CGAffineTransform(translationX: x, y: y))
    }
}
