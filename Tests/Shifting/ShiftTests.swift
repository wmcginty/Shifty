//
//  ShiftTests.swift
//  Shifty-Tests
//
//  Created by William McGinty on 12/29/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import Shifty

class ShiftTests: XCTestCase {
    
    class MockView: UIView {
        var hasLaidOutSubviews = false
        
        override func layoutSubviews() {
            hasLaidOutSubviews = true
        }
    }
    
    func testShift_equalityDependsOnSourceAndDestinationIdentifiers() {
        let s = Shift.Target(view: UIView(), identifier: .mock)
        let d = Shift.Target(view: UIView(), identifier: .mock)
        
        let a = Shift(source: s, destination: d)
        let b = Shift(source: s, destination: d)
        let c = Shift(source: s, destination: d)
        
        XCTAssertEqual(a, b)
        XCTAssertEqual(a, c)
        XCTAssertEqual(b, c)
    }
    
    func testShift_notEqualWhenEitherIdentifierIsDifferent() {
        let view = UIView()
        let s = Shift.Target(view: view, identifier: .mock)
        let d = Shift.Target(view: view, identifier: .mock)
        let s2 = Shift.Target(view: view, identifier: .other)
        let d2 = Shift.Target(view: view, identifier: .other)
        
        let a = Shift(source: s, destination: d)
        let b = Shift(source: s2, destination: d)
        let c = Shift(source: s, destination: d2)
        let e = Shift(source: s2, destination: d2)
        
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(a, c)
        XCTAssertNotEqual(a, e)
    }
    
    func testShift_hashEqualityDependsOnSourceAndDestinationIdentifiers() {
        let s = Shift.Target(view: UIView(), identifier: .mock)
        let d = Shift.Target(view: UIView(), identifier: .mock)
        
        let a = Shift(source: s, destination: d)
        let b = Shift(source: s, destination: d)
        
        XCTAssertEqual(a.hashValue, b.hashValue)
    }
    
    func testShift_hashNotEqualWhenEitherIdentifierIsDifferent() {
        let s = Shift.Target(view: UIView(), identifier: .mock)
        let d = Shift.Target(view: UIView(), identifier: .third)
        let d2 = Shift.Target(view: UIView(), identifier: .mock)
        
        let a = Shift(source: s, destination: d)
        let b = Shift(source: s, destination: d2)
        
        XCTAssertNotEqual(a.hashValue, b.hashValue)
    }
    
    func testShift_correctlySnapshotsDestinationTarget() {
        let s = Shift.Target(view: UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)), identifier: .mock)
        let d = Shift.Target(view: UIView(frame: CGRect(x: 50, y: 0, width: 50, height: 50)), identifier: .mock)
        let a = Shift(source: s, destination: d)
        
        let snap1 = a.destinationSnapshot()
        let snap2 = a.destination.snapshot()
        
        XCTAssertEqual(snap1, snap2)
        XCTAssertNotEqual(snap1, a.source.snapshot())
    }
    
    func testShift_correctlyHidesBothNativeViews() {
        let v1 = UIView()
        let v2 = UIView()
        let a = Shift(source: Shift.Target(view: v1, identifier: .mock), destination: Shift.Target(view: v2, identifier: .mock))
        
        XCTAssertFalse(v1.isHidden)
        XCTAssertFalse(v2.isHidden)
        
        a.configureNativeViews(hidden: true)
        XCTAssertTrue(v1.isHidden)
        XCTAssertTrue(v2.isHidden)
        
        a.configureNativeViews(hidden: false)
        XCTAssertFalse(v1.isHidden)
        XCTAssertFalse(v2.isHidden)
    }
    
    func testShift_properlyCleansUpReplicantAndReinstallsNativeViews() {
        let sView = UIView()
        let dView = UIView()
        let s = Shift.Target(view: sView, identifier: .mock)
        let d = Shift.Target(view: dView, identifier: .mock)
        let shift = Shift(source: s, destination: d)
        
        let replicant = UIView()
        let superview = UIView()
        superview.addSubview(replicant)
        
        shift.configureNativeViews(hidden: true)
        shift.cleanup(replicant: replicant)
        
        XCTAssertNil(replicant.superview)
        XCTAssertFalse(sView.isHidden)
        XCTAssertFalse(dView.isHidden)
    }
    
    func testShift_properlyConfiguresReplicantView() {
        let superview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let view = UIView(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
        superview.addSubview(view)
        
        let s = Shift.Target(view: view, identifier: .mock, replicationStrategy: .debug)
        let d = Shift.Target(view: UIView(), identifier: .mock)
        let shift = Shift(source: s, destination: d)
        
        let replicant = shift.configuredReplicant(in: superview)
        
        XCTAssertEqual(replicant.bounds.size, CGSize(width: 50, height: 50))
        XCTAssertEqual(replicant.center, CGPoint(x: 75, y: 75))
    }
    
    func testShift_correctlyAppliesVisualSnapshotToReplicantView() {
        let destination = UIView(frame: .zero)
        destination.backgroundColor = .red
        destination.alpha = 0.25
        destination.layer.cornerRadius = 3
        
        let s = Shift.Target(view: UIView(), identifier: .mock, replicationStrategy: .debug)
        let d = Shift.Target(view: destination, identifier: .mock)
        let shift = Shift(source: s, destination: d)
       
        let replicant = UIView()
        shift.visualShift(for: replicant)
        
        XCTAssertEqual(replicant.backgroundColor, .red)
        XCTAssertEqual(replicant.alpha, 0.25, accuracy: 0.01)
        XCTAssertEqual(replicant.layer.cornerRadius, 3)
    }
    
    func testShift_correctlyAppliesPositionalSnapshotToReplicantView() {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        let superview = UIView(frame: CGRect(x: 300, y: 300, width: 200, height: 200))
        container.addSubview(superview)
        
        let destination = UIView(frame: .zero)
        destination.bounds = CGRect(x: 0, y: 0, width: 150, height: 200)
        destination.center = CGPoint(x: 100, y: 100)
        superview.addSubview(destination)
        
        let s = Shift.Target(view: UIView(), identifier: .mock, replicationStrategy: .debug)
        let d = Shift.Target(view: destination, identifier: .mock)
        let shift = Shift(source: s, destination: d)

        let replicant = UIView()
        container.addSubview(replicant)
        shift.positionalShift(for: replicant)
  
        XCTAssertEqual(replicant.center, CGPoint(x: 400, y: 400))
        XCTAssertEqual(replicant.bounds, CGRect(x: 0, y: 0, width: 150, height: 200))
    }
    
    func testShift_correctlyLaysOutDestinationSuperview() {
        let view = MockView(frame: .zero)
        let child = UIView(frame: .zero)
        view.addSubview(child)
        
        XCTAssertEqual(child.frame, .zero)
        
        let s = Shift.Target(view: UIView(), identifier: .mock, replicationStrategy: .debug)
        let d = Shift.Target(view: child, identifier: .mock)
        let shift = Shift(source: s, destination: d)
        shift.layoutDestinationIfNeeded()
        
        XCTAssertTrue(view.hasLaidOutSubviews)
    }
    
    func testShift_correctlyGeneratesDebugShift() {
        let container = UIView()
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        container.addSubview(view)
        
        let s = Shift.Target(view: view, identifier: .mock)
        let d = Shift.Target(view: UIView(), identifier: .mock)
        let shift = Shift(source: s, destination: d)
        let debug = shift.debug
        
        let testReplicant = debug.configuredReplicant(in: container)
        let debugReplicant = ReplicationStrategy.debug.configuredShiftingView(for: s.view, afterScreenUpdates: false)
        
        XCTAssertEqual(testReplicant.backgroundColor, debugReplicant.backgroundColor)
        XCTAssertEqual(testReplicant.bounds, debugReplicant.bounds)
        XCTAssertEqual(testReplicant.alpha, debugReplicant.alpha)
    }
}
