//
//  Coalesced.swift
//  Shifty
//
//  Created by William McGinty on 9/13/16.
//
//

import Foundation

class Coalesced<T> {
    
    var objects = [T]()
    
    init() { }
    
    func coalesce(_ object: T) {
        objects.append(object)
    }
}
