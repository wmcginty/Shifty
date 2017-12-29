//
//  AnimatorTests.swift
//  Shifty_Tests
//
//  Created by William McGinty on 12/29/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import Shifty

class AnimatorTests: XCTestCase {
    
    func testAnimatorInitializerFromAny() {
        XCTAssertNil(ShiftAnimator(source: UIView(), destination: UIView()))
    }
}
