//
//  Collection+Dictionary.swift
//  ShiftKit
//
//  Created by William McGinty on 6/8/16.
//  Copyright © 2016 will.mcginty. All rights reserved.
//

import Foundation

extension Collection {
    
    /**
        Convert a collection into a dictionary representation.
        
        - parameter transformer: The function that converts each element (of type `Generator.Element`) into a key, value tuple. Note that the key type must conform to `Hashable`.
        - returns: A dictionary representation of `self` created by applying `transformer`. If 'self' is empty, an empty dictionary is returned.
     */
    func dictionary<T: Hashable, V>(_ transformer: @noescape (Generator.Element) -> (key: T, value: V)) -> Dictionary<T, V> {
        return self.reduce([:]) { dictionary, element in
            var dict = dictionary
            
            let (key, value) = transformer(element)
            dict[key] = value
            
            return dict
        }
    }
}
