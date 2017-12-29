//
//  ShiftTests.swift
//  Shifty_Example
//
//  Created by William McGinty on 12/29/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import Shifty

class ShiftTests: XCTestCase {
    
    func testShiftEquality() {
        let s = Shiftable(view: UIView(), identifier: "id")
        let d = Shiftable(view: UIView(), identifier: "id")
        
        let a = Shift(source: s, destination: d, animationParameters: .default)
        let b = Shift(source: s, destination: d, animationParameters: .default)
        let c = Shift(source: s, destination: d, animationParameters: AnimationParameters(timingCurve: UISpringTimingParameters(dampingRatio: 1.0)))
        
        XCTAssertEqual(a, b)
        XCTAssertEqual(a, c)
    }
    
    func testShiftInequality() {
        let s = Shiftable(view: UIView(), identifier: "id")
        let d = Shiftable(view: UIView(), identifier: "id")
        let s2 = Shiftable(view: UIView(), identifier: "id2")
        let d2 = Shiftable(view: UIView(), identifier: "id2")
        
        let a = Shift(source: s, destination: d, animationParameters: .default)
        let b = Shift(source: s2, destination: d, animationParameters: .default)
        let c = Shift(source: s, destination: d2, animationParameters: .default)
        let e = Shift(source: s2, destination: d2, animationParameters: .default)
        
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(a, c)
        XCTAssertNotEqual(a, e)
    }
    
    func testShiftHashEquality() {
        let s = Shiftable(view: UIView(), identifier: "id")
        let d = Shiftable(view: UIView(), identifier: "id")
        
        let a = Shift(source: s, destination: d, animationParameters: .default)
        let b = Shift(source: s, destination: d, animationParameters: AnimationParameters(timingCurve: UISpringTimingParameters(dampingRatio: 1.0)))
        
        XCTAssertEqual(a.hashValue, b.hashValue)
    }
    
    func testShiftDestinationSnapshotting() {
        let s = Shiftable(view: UIView(), identifier: "id")
        let d = Shiftable(view: UIView(), identifier: "id")
        
        let a = Shift(source: s, destination: d, animationParameters: .default)
        let snap1 = a.destinationSnapshot()
        let snap2 = a.destination.currentSnapshot()
        
        XCTAssertEqual(snap1, snap2)
    }
    
    func testShiftHidingNativeViews() {
        let v1 = UIView()
        let v2 = UIView()
        let a = Shift(source: Shiftable(view: v1, identifier: "id"), destination: Shiftable(view: v2, identifier: "id"))
        
        XCTAssertFalse(v1.isHidden)
        XCTAssertFalse(v2.isHidden)
        a.configureNativeViews(hidden: true)
        XCTAssertTrue(v1.isHidden)
        XCTAssertTrue(v2.isHidden)
        
    }
}
