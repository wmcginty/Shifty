//
//  CollectionType+Dictionary.swift
//  ShiftKit
//
//  Created by William McGinty on 6/8/16.
//  Copyright © 2016 will.mcginty. All rights reserved.
//

import Foundation

extension Collection {
    func dictionary<T: Hashable, V>(transformer: (element: Generator.Element) -> (key: T, value: V)) -> Dictionary<T, V> {
        return self.reduce([:]) { dictionary, element in
            var dict = dictionary
            
            let (key, value) = transformer(element: element)
            dict[key] = value
            
            return dict
        }
    }
}
