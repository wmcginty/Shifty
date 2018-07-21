//
//  StateTests.swift
//  Shifty_Example
//
//  Created by William McGinty on 12/29/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import Shifty

class StateTests: XCTestCase {
    
    func testStateEquality() {
        let view = UIView()
        let state1 = State(view: view, identifier: "identifier")
        let state2 = State(view: UIView(), identifier: "identifier")
        let state3 = State(view: view, identifier: "identifier")
        
        XCTAssertEqual(state1, state2)
        XCTAssertEqual(state1, state3)
    }
    
    func testStateInequality() {
        let view = UIView()
        let state1 = State(view: view, identifier: "identifier")
        let state2 = State(view: UIView(), identifier: "other")
        let state3 = State(view: view, identifier: "otheridentifier")
        
        XCTAssertNotEqual(state1, state2)
        XCTAssertNotEqual(state1, state3)
    }
    
    func testStateHashEquality() {
        let a = State(view: UIView(), identifier: "identifier")
        let b = State(view: UIView(), identifier: "identifier")
        
        XCTAssertEqual(a.hashValue, b.hashValue)
    }
    
    func testStateHashInequality() {
        let a = State(view: UIView(), identifier: "identifier")
        let b = State(view: UIView(), identifier: "other")
        
        XCTAssertNotEqual(a.hashValue, b.hashValue)
    }
    
    func testStateSnapshots() {
        let view = UIView()
        let a = State(view: view, identifier: "identifier")
        let snap = a.snapshot()
        
        XCTAssertEqual(snap.center, .zero)
        XCTAssertEqual(snap.bounds, .zero)
        XCTAssertEqual(snap.transform, CATransform3DIdentity)
        
        let c = CGPoint(x: 50, y: 50)
        let b = CGRect(origin: .zero, size: CGSize(width: 200, height: 200))
        let t = CGAffineTransform(translationX: 20, y: 20)
        
        view.center = c
        view.bounds = b
        view.transform = t

        let snap2 = a.snapshot()
        
        XCTAssertEqual(snap2.center, c)
        XCTAssertEqual(snap2.bounds, b)
        XCTAssertEqual(snap2.transform, CATransform3DMakeAffineTransform(t))
    }
}
