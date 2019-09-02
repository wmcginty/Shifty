//
//  ShiftTargetTests.swift
//  Shifty-Tests
//
//  Created by William McGinty on 12/29/17.
//  Copyright © 2017 Will McGinty. All rights reserved.
//

import XCTest
@testable import Shifty

extension Shift.Identifier {
    static let mock = Shift.Identifier(rawValue: "mock")
    static let other = Shift.Identifier(rawValue: "other")
    static let third = Shift.Identifier(rawValue: "third")
}

class ShiftTargetTests: XCTestCase {
    
    func testShiftTarget_equalityDependsOnlyOnIdentifier() {
        let state1 = Shift.Target(view: UIView(), identifier: .mock)
        let state2 = Shift.Target(view: UIView(), identifier: .mock)
        let state3 = Shift.Target(view: UIView(), identifier: .mock)
        
        XCTAssertEqual(state1, state2)
        XCTAssertEqual(state1, state3)
        XCTAssertEqual(state2, state3)
    }
    
    func testShiftTarget_notEqualWhenIdentifierDiffers() {
        let view = UIView()
        let state1 = Shift.Target(view: view, identifier: .mock)
        let state2 = Shift.Target(view: view, identifier: .other)
        let state3 = Shift.Target(view: view, identifier: .third)
        
        XCTAssertNotEqual(state1, state2)
        XCTAssertNotEqual(state1, state3)
        XCTAssertNotEqual(state2, state3)
    }
    
    func testShiftTarget_hashEqualityDependsOnlyOnIdentifier() {
        let a = Shift.Target(view: UIView(), identifier: .mock)
        let b = Shift.Target(view: UIView(), identifier: .mock)
        
        XCTAssertEqual(a.hashValue, b.hashValue)
    }
    
    func testShiftTarget_hashNotEqualWhenIdentifierDiffers() {
        let a = Shift.Target(view: UIView(), identifier: .mock)
        let b = Shift.Target(view: UIView(), identifier: .other)
        
        XCTAssertNotEqual(a.hashValue, b.hashValue)
    }
    
    func testShiftTarget_snapshotGeneratedMatchesViewProperties() {
        let view = UIView()
        let a = Shift.Target(view: view, identifier: .mock)
        
        //Snapshot default view properties
        let snap = a.snapshot()
        XCTAssertEqual(snap.center, .zero)
        XCTAssertEqual(snap.bounds, .zero)
        XCTAssertEqual(snap.transform3D, CATransform3DIdentity)
        
        //Modify then snapshot view properties
        let c = CGPoint(x: 50, y: 50)
        let b = CGRect(origin: .zero, size: CGSize(width: 200, height: 200))
        let t = CGAffineTransform(translationX: 20, y: 20)
        
        view.center = c
        view.bounds = b
        view.transform = t
        
        let snap2 = a.snapshot()
        XCTAssertEqual(snap2.center, c)
        XCTAssertEqual(snap2.bounds, b)
        XCTAssertEqual(snap2.transform3D, CATransform3DMakeAffineTransform(t))
    }
    
    func testShiftTarget_correctlyAltersNativeView() {
        let view = UIView()
        let a = Shift.Target(view: view, identifier: .mock)
        
        a.configureNativeView(hidden: true)
        XCTAssertTrue(view.isHidden)
        
        a.configureNativeView(hidden: false)
        XCTAssertFalse(view.isHidden)
    }
    
    func testShiftTarget_correctlyCleansUpWhenAskedToReinstallNativeView() {
        let view = UIView()
        let a = Shift.Target(view: view, identifier: .mock)
        
        let superview = UIView()
        let replicant = UIView()
        superview.addSubview(replicant)
        
        a.configureNativeView(hidden: true)
        a.cleanup(replicant: replicant, restoreNativeView: true)
        XCTAssertNil(replicant.superview)
        XCTAssertFalse(view.isHidden)
    }
    
    func testShiftTarget_correctlyCleansUpWhenAskedToNotReinstallNativeView() {
        let view = UIView()
        let a = Shift.Target(view: view, identifier: .mock)
        
        let superview = UIView()
        let replicant = UIView()
        superview.addSubview(replicant)
        
        a.configureNativeView(hidden: true)
        a.cleanup(replicant: replicant, restoreNativeView: false)
        XCTAssertNil(replicant.superview)
        XCTAssertTrue(view.isHidden)
    }
    
    func testShiftTarget_properlyConfiguresReplicantView() {
        let superview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let view = UIView(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
        superview.addSubview(view)
        
        let a = Shift.Target(view: view, identifier: .mock, replicationStrategy: .debug)
        let replicant = a.configuredReplicant(in: superview, afterScreenUpdates: true)
        
        XCTAssertEqual(replicant.bounds.size, CGSize(width: 50, height: 50))
        XCTAssertEqual(replicant.center, CGPoint(x: 75, y: 75))
    }
    
    func testShiftTarget_correctlyGeneratesDebugTarget() {
        let container = UIView()
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
        container.addSubview(view)
        
        let target = Shift.Target(view: view, identifier: .mock)
        let debug = target.debug
        
        XCTAssertEqual(target.identifier, debug.identifier)
        XCTAssert(target.view === debug.view)
        
        let debugReplicant = debug.configuredReplicant(in: container, afterScreenUpdates: false)
        let testReplicant = ReplicationStrategy.debug.configuredShiftingView(for: view, afterScreenUpdates: false)
        
        XCTAssertEqual(testReplicant.backgroundColor, debugReplicant.backgroundColor)
        XCTAssertEqual(testReplicant.bounds, debugReplicant.bounds)
        XCTAssertEqual(testReplicant.alpha, debugReplicant.alpha)
    }
}
