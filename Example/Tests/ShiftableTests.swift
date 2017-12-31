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
        let a = State(view: view, identifier: "identifier")
        let b = State(view: UIView(), identifier: "identifier")
        let c = State(view: view, identifier: "identifier")
        
        XCTAssertEqual(a, b)
        XCTAssertEqual(a, c)
    }
    
    func testStateInequality() {
        let view = UIView()
        let a = State(view: view, identifier: "identifier")
        let b = State(view: UIView(), identifier: "other")
        let c = State(view: view, identifier: "otheridentifier")
        
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(a, c)
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
        let snap = a.currentSnapshot()
        
        XCTAssertEqual(snap.center, .zero)
        XCTAssertEqual(snap.bounds, .zero)
        XCTAssertEqual(snap.transform, CATransform3DIdentity)
        
        let c = CGPoint(x: 50, y: 50)
        let b = CGRect(origin: .zero, size: CGSize(width: 200, height: 200))
        let t = CGAffineTransform(translationX: 20, y: 20)
        
        view.center = c
        view.bounds = b
        view.transform = t

        let snap2 = a.currentSnapshot()
        
        XCTAssertEqual(snap2.center, c)
        XCTAssertEqual(snap2.bounds, b)
        XCTAssertEqual(snap2.transform, CATransform3DMakeAffineTransform(t))
    }
}
