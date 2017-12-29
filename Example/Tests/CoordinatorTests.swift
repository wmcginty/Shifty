//
//  CoordinatorTests.swift
//  Shifty_Tests
//
//  Created by William McGinty on 12/29/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import Shifty

class CoordinatorTests: XCTestCase {
    
    func testDefaultCoordinatorMatchingEmptyInput() {
        let c = DefaultShiftCoordinator()
        let s = c.shifts(from: [], to: [])
        XCTAssertEqual(s, [])
    }
    
    func testDefaultCoordinatorMatchingInputs() {
        let c = DefaultShiftCoordinator()
        let s = c.shifts(from: [Shiftable(view: UIView(), identifier: "id2"),
                                Shiftable(view: UIView(), identifier: "id")], to: [Shiftable(view: UIView(), identifier: "id")])
        XCTAssertEqual(s.count, 1)
        XCTAssertTrue(s.first!.source.identifier == AnyHashable("id"))
        XCTAssertTrue(s.first!.destination.identifier == AnyHashable("id"))
        XCTAssertFalse(s.contains(where: { $0.source.identifier == AnyHashable("id2") }))
    }
    
    func testDefaultCoordinatorNoMatchingInputs() {
        let c = DefaultShiftCoordinator()
        let s = c.shifts(from: [Shiftable(view: UIView(), identifier: "id2")], to: [Shiftable(view: UIView(), identifier: "id")])
        XCTAssertTrue(s.isEmpty)
    }
}
