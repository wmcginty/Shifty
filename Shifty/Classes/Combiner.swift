//
//  Combiner.swift
//  Pods
//
//  Created by William McGinty on 9/12/16.
//
//

import Foundation

/// A simple object that contains the interface to combine closures of various types
struct Combiner {
    
    typealias VoidFunc = () -> Void
    typealias BoolFunc = (Bool) -> Void
    
    /// Combines two void returning closures into a single new closure.
    ///
    /// - parameter block: The closure to add.
    /// - parameter to:    The closure being added to.
    ///
    /// - returns: A new copy of 'to', where both 'to' and 'block are executed.
    static func add(_ block: @escaping VoidFunc, to: VoidFunc?) -> VoidFunc {
        let current = to
        
        return {
            current?()
            block()
        }
    }
    
    /// Combines two void returning closures (with bool parameters) into a single new closure.
    ///
    /// - parameter block: The closure to add.
    /// - parameter to:    The closure being added to.
    ///
    /// - returns: A new copy of 'to', where both 'to' and 'block are executed.
    static func add(_ block: @escaping BoolFunc, to: BoolFunc?) -> BoolFunc {
        let current = to
        
        return { bool in
            current?(bool)
            block(bool)
        }
    }
}
