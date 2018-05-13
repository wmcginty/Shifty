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
        let snap1 = Snapshot(center: .zero, bounds: .zero, transform: CATransform3DIdentity, cornerRadius: 0)
        let snap2 = Snapshot(center: .zero, bounds: .zero, transform: CATransform3DIdentity, cornerRadius: 0)
       
        XCTAssertEqual(snap1, snap2)
    }
    
    func testSnapshotInequality() {
        let snap1 = Snapshot(center: .zero, bounds: .zero, transform: CATransform3DIdentity, cornerRadius: 0)
        let snap2 = Snapshot(center: CGPoint(x: 10, y: 10), bounds: .zero, transform: CATransform3DIdentity, cornerRadius: 0)
        let snap3 = Snapshot(center: .zero, bounds: CGRect(origin: .zero, size: CGSize(width: 10, height: 10)), transform: CATransform3DIdentity, cornerRadius: 0)
        let snap4 = Snapshot(center: .zero, bounds: .zero, transform: CATransform3DScale(CATransform3DIdentity, 1.1, 1.1, 1.1), cornerRadius: 0)
        let snap5 = Snapshot(center: .zero, bounds: .zero, transform: CATransform3DIdentity, cornerRadius: 5)
        
        XCTAssertNotEqual(snap1, snap2)
        XCTAssertNotEqual(snap1, snap3)
        XCTAssertNotEqual(snap1, snap4)
        XCTAssertNotEqual(snap1, snap5)
    }
}
