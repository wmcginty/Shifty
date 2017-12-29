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
        let a = Snapshot(center: .zero, bounds: .zero, transform: .identity, transform3d: CATransform3DIdentity)
        let b = Snapshot(center: .zero, bounds: .zero, transform: .identity, transform3d: CATransform3DIdentity)
       
        XCTAssertEqual(a, b)
    }
    
    func testSnapshotInequality() {
        let a = Snapshot(center: .zero, bounds: .zero, transform: .identity, transform3d: CATransform3DIdentity)
        let b = Snapshot(center: CGPoint(x: 10, y: 10), bounds: .zero, transform: .identity, transform3d: CATransform3DIdentity)
        let c = Snapshot(center: .zero, bounds: CGRect(origin: .zero, size: CGSize(width: 10, height: 10)), transform: .identity, transform3d: CATransform3DIdentity)
        let d = Snapshot(center: .zero, bounds: .zero, transform: CGAffineTransform(scaleX: 2.2, y: 2.2), transform3d: CATransform3DIdentity)
        let e = Snapshot(center: .zero, bounds: .zero, transform: .identity, transform3d: CATransform3DScale(CATransform3DIdentity, 1.1, 1.1, 1.1))
        
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(a, c)
        XCTAssertNotEqual(a, d)
        XCTAssertNotEqual(a, e)
    }
}
