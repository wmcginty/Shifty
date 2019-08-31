//
//  ShiftIdentifierTests.swift
//  Shifty-Tests
//
//  Created by William McGinty on 8/31/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import Shifty

class ShiftIdentifierTests: XCTestCase {
    
    func testShiftIdentifer_hashValuesEqualWhenRawValueEqual() {
        let a = Shift.Identifier(rawValue: "abc")
        let b = Shift.Identifier(rawValue: "abc")
        
        XCTAssertEqual(a, b)
        XCTAssertEqual(a.hashValue, b.hashValue)
    }
    
    func testShiftIdentifer_hashValuesNotEqualWhenRawValueNotEqual() {
        let a = Shift.Identifier(rawValue: "abc")
        let b = Shift.Identifier(rawValue: "ab")
        
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(a.hashValue, b.hashValue)
    }
}
