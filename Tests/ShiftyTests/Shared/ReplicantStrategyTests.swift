//
//  ReplicantStrategyTests.swift
//  Shifty-Tests
//
//  Created by William McGinty on 8/30/19.
//  Copyright © 2019 Will McGinty. All rights reserved.
//

import XCTest
import SnapshotTesting
import Shifty

class ReplicantStrategyTests: XCTestCase {
    
    func testReplicantStrategy_testNoneStrategyWithView() {
        let original = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        original.backgroundColor = .red
        
        let strategy = ReplicationStrategy.none
        XCTAssertEqual(original, strategy.configuredShiftingView(for: original, afterScreenUpdates: true))
    }
    
    func testReplicantStrategy_testNoneStrategyWithLabel() {
        let original = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 25)))
        original.text = "hello world"
        original.backgroundColor = .red
        
        let strategy = ReplicationStrategy.none
        XCTAssertEqual(original, strategy.configuredShiftingView(for: original, afterScreenUpdates: true))
    }
    
    func testReplicantStrategy_testConfiguredStrategyWithView() {
        let original = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        original.backgroundColor = .red
        
        let strategy = ReplicationStrategy.configured { baseView -> UIView in
            let view = UIView(frame: CGRect(origin: baseView.frame.origin, size: baseView.frame.size.applying(CGAffineTransform(scaleX: 0.5, y: 2))))
            view.backgroundColor = .purple
            return view
        }
        
        let snapshot = strategy.configuredShiftingView(for: original, afterScreenUpdates: true)

        XCTAssertEqual(snapshot.frame.width, 50)
        XCTAssertEqual(snapshot.frame.height, 200)
        XCTAssertEqual(snapshot.backgroundColor, .purple)
        
        //assertSnapshot(matching: snapshot, as: .image)
    }

    /*
    func testReplicantStrategy_testDebugStrategyWithView() {
        let original = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        original.backgroundColor = .purple
        
        let strategy = ReplicationStrategy.debug
        assertSnapshot(matching: strategy.configuredShiftingView(for: original, afterScreenUpdates: true), as: .image)
    }
    
    func testReplicantStrategy_testDebugStrategyWithLabel() {
        let original = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 25)))
        original.text = "hello world"
        original.backgroundColor = .purple
        
        let strategy = ReplicationStrategy.debug
        assertSnapshot(matching: strategy.configuredShiftingView(for: original, afterScreenUpdates: true), as: .image)
    }
    */
}
