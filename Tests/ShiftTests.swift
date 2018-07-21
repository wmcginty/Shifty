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
        let s = State(view: UIView(), identifier: "id")
        let d = State(view: UIView(), identifier: "id")
        
        let a = Shift(source: s, destination: d)
        let b = Shift(source: s, destination: d)
        let c = Shift(source: s, destination: d, animationContext: SpringAnimationContext(timingParameters: UISpringTimingParameters(dampingRatio: 1.0)))
        
        XCTAssertEqual(a, b)
        XCTAssertEqual(a, c)
    }
    
    func testShiftInequality() {
        let s = State(view: UIView(), identifier: "id")
        let d = State(view: UIView(), identifier: "id")
        let s2 = State(view: UIView(), identifier: "id2")
        let d2 = State(view: UIView(), identifier: "id2")
        
        let a = Shift(source: s, destination: d)
        let b = Shift(source: s2, destination: d)
        let c = Shift(source: s, destination: d2)
        let e = Shift(source: s2, destination: d2)
        
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(a, c)
        XCTAssertNotEqual(a, e)
    }
    
    func testShiftHashEquality() {
        let s = State(view: UIView(), identifier: "id")
        let d = State(view: UIView(), identifier: "id")
        
        let a = Shift(source: s, destination: d)
        let b = Shift(source: s, destination: d, animationContext: SpringAnimationContext(timingParameters: UISpringTimingParameters(dampingRatio: 1.0)))
        
        XCTAssertEqual(a.hashValue, b.hashValue)
    }
    
    func testShiftDestinationSnapshotting() {
        let s = State(view: UIView(), identifier: "id")
        let d = State(view: UIView(), identifier: "id")
        
        let a = Shift(source: s, destination: d)
        let snap1 = a.destinationSnapshot()
        let snap2 = a.destination.snapshot()
        
        XCTAssertEqual(snap1, snap2)
    }
    
    func testShiftHidingNativeViews() {
        let v1 = UIView()
        let v2 = UIView()
        let a = Shift(source: State(view: v1, identifier: "id"), destination: State(view: v2, identifier: "id"))
        
        XCTAssertFalse(v1.isHidden)
        XCTAssertFalse(v2.isHidden)
        a.configureNativeViews(hidden: true)
        XCTAssertTrue(v1.isHidden)
        XCTAssertTrue(v2.isHidden)
    }
    
    func testShiftCleanup() {
        let sView = UIView()
        let dView = UIView()
        let s = State(view: sView, identifier: "id")
        let d = State(view: dView, identifier: "id")
        let shift = Shift(source: s, destination: d)
        
        let test = UIView()
        let superview = UIView()
        superview.addSubview(test)
        
        shift.configureNativeViews(hidden: true)
        shift.cleanupShiftingView(test)
        
        XCTAssertNil(test.superview)
        XCTAssertFalse(sView.isHidden)
        XCTAssertFalse(dView.isHidden)
    }
}
