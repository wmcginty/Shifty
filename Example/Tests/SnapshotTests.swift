//
//  SnapshotTests.swift
//  Shifty_Example
//
//  Created by William McGinty on 12/29/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import Shifty

class SnapshotTests: XCTestCase {
    
    func testSnapshotEquality() {
        let a = Snapshot(center: .zero, bounds: .zero, transform: CATransform3DIdentity)
        let b = Snapshot(center: .zero, bounds: .zero, transform: CATransform3DIdentity)
       
        XCTAssertEqual(a, b)
    }
    
    func testSnapshotInequality() {
        let a = Snapshot(center: .zero, bounds: .zero, transform: CATransform3DIdentity)
        let b = Snapshot(center: CGPoint(x: 10, y: 10), bounds: .zero, transform: CATransform3DIdentity)
        let c = Snapshot(center: .zero, bounds: CGRect(origin: .zero, size: CGSize(width: 10, height: 10)), transform: CATransform3DIdentity)
        let d = Snapshot(center: .zero, bounds: .zero, transform: CATransform3DIdentity)
        let e = Snapshot(center: .zero, bounds: .zero, transform: CATransform3DScale(CATransform3DIdentity, 1.1, 1.1, 1.1))
        
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(a, c)
        XCTAssertNotEqual(a, d)
        XCTAssertNotEqual(a, e)
    }
    
    func testX() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        print("Identity")
        print(CGAffineTransform.identity)
        view.layer.transform = CATransform3DMakeRotation(.pi, 1, 1, 0)
        let superview = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        superview.addSubview(view)
        
        print("Layer Affine")
        print(view.layer.affineTransform())
        
        print("View Transform")
        print(view.transform)
        
        print()
    }
}
