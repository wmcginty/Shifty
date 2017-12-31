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
        let a = Snapshot(center: .zero, bounds: .zero, transform: CATransform3DIdentity, cornerRadius: 0)
        let b = Snapshot(center: .zero, bounds: .zero, transform: CATransform3DIdentity, cornerRadius: 0)
       
        XCTAssertEqual(a, b)
    }
    
    func testSnapshotInequality() {
        let a = Snapshot(center: .zero, bounds: .zero, transform: CATransform3DIdentity, cornerRadius: 0)
        let b = Snapshot(center: CGPoint(x: 10, y: 10), bounds: .zero, transform: CATransform3DIdentity, cornerRadius: 0)
        let c = Snapshot(center: .zero, bounds: CGRect(origin: .zero, size: CGSize(width: 10, height: 10)), transform: CATransform3DIdentity, cornerRadius: 0)
        let d = Snapshot(center: .zero, bounds: .zero, transform: CATransform3DScale(CATransform3DIdentity, 1.1, 1.1, 1.1), cornerRadius: 0)
        let e = Snapshot(center: .zero, bounds: .zero, transform: CATransform3DIdentity, cornerRadius: 5)
        
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(a, c)
        XCTAssertNotEqual(a, d)
        XCTAssertNotEqual(a, e)
    }
}
