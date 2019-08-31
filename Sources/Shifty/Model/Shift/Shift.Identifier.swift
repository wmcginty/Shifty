//
//  Shift.Identifier.swift
//  Shifty
//
//  Created by William McGinty on 8/30/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

public extension Shift {
    
    struct Identifier: RawRepresentable, Hashable {
        
        // MARK: Properties
        public let rawValue: String
        
        // MARK: Initializers
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        // MARK: Hashable
        public func hash(into hasher: inout Hasher) {
            hasher.combine(rawValue)
        }
    }
}
