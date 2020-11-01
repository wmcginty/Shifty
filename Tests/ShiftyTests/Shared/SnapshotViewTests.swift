//
//  SnapshotViewTests.swift
//  Shifty-Tests
//
//  Created by William McGinty on 8/31/19.
//  Copyright © 2019 Will McGinty. All rights reserved.
//

import XCTest
@testable import Shifty

class SnapshotViewTests: XCTestCase {
    
    func testSnapshotView_configuresWithViewProperly() {
        let content = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 30)))
        content.backgroundColor = .green
        content.text = "hello world"
        
        let snapshot = SnapshotView(contentView: content)
        snapshot.bounds = CGRect(origin: .zero, size: CGSize(width: 100, height: 30))
    }
    
    func testSnapshotView_maintainsContentViewInSelf() {
        let content = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 30)))
        content.backgroundColor = .green
        content.text = "hello world"
        
        let snapshot = SnapshotView(contentView: content)
        snapshot.backgroundColor = .cyan
        snapshot.bounds = CGRect(origin: .zero, size: CGSize(width: 100, height: 30))
        XCTAssertEqual(snapshot.contentView.frame, snapshot.bounds)
        
        snapshot.bounds = CGRect(origin: .zero, size: CGSize(width: 200, height: 60))
        snapshot.layoutIfNeeded()
        XCTAssertEqual(snapshot.contentView.frame, snapshot.bounds)
        
        snapshot.bounds = CGRect(origin: .zero, size: CGSize(width: 150, height: 60))
        snapshot.layoutIfNeeded()
        XCTAssertEqual(snapshot.contentView.frame, snapshot.bounds)
    }
}
