//
//  Combiner.swift
//  Pods
//
//  Created by William McGinty on 9/12/16.
//
//

import Foundation

struct Combiner {
    
    typealias VoidFunc = () -> Void
    static func add(_ block: @escaping VoidFunc, to: VoidFunc?) -> VoidFunc {
        let current = to
        
        return {
            current?()
            block()
        }
    }
    
    typealias BoolFunc = (Bool) -> Void
    static func add(_ block: @escaping BoolFunc, to: BoolFunc?) -> BoolFunc {
        let current = to
        
        return { bool in
            current?(bool)
            block(bool)
        }
    }
}
