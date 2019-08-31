//
//  TimingProviderTests.swift
//  Shifty-Tests
//
//  Created by William McGinty on 8/31/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import Shifty

class TimingProviderTests: XCTestCase {
    
    func testSpringTimingParameters_durationIsZeroWhenInitializedWithMass() {
        let provider = SpringTimingProvider(mass: 1, stiffness: 1, damping: 1, initialVelocity: CGVector(dx: 1, dy: 1))
        XCTAssertEqual(provider.duration, 0)
        
        let provider2 = SpringTimingProvider(mass: 10, stiffness: 2, damping: 13, initialVelocity: CGVector(dx: 4, dy: 4))
        XCTAssertEqual(provider2.duration, 0)
    }
    
    func testSpringTimingParameters_durationIsRespectedWhenInitializedWithDamping() {
        let provider = SpringTimingProvider(duration: 1.5, dampingRatio: 1.0)
        XCTAssertEqual(provider.duration, 1.5)
        
        let provider2 = SpringTimingProvider(duration: 2.5, dampingRatio: 1.0, initialVelocity: CGVector.zero)
        XCTAssertEqual(provider2.duration, 2.5)
    }
    
    func testSpringTimingParameters_initialVelocityDefaultsToZero() {
        let provider = SpringTimingProvider(duration: 1.5, dampingRatio: 1.0)
        XCTAssertEqual(provider.parameters.springTimingParameters?.initialVelocity, .zero)
    }
    
    func testCubicTimingParameters_durationIsAlwaysRespected() {
        let provider = CubicTimingProvider(duration: 1.5, curve: .linear)
        XCTAssertEqual(provider.duration, 1.5)
        
        let provider2 = CubicTimingProvider(duration: 1, controlPoint1: CGPoint(x: 0, y: 0), controlPoint2: CGPoint(x: 1, y: 1))
        XCTAssertEqual(provider2.duration, 1)
        
        let provider3 = CubicTimingProvider(duration: 2, parameters: UICubicTimingParameters(animationCurve: .easeIn))
        XCTAssertEqual(provider3.duration, 2)
    }
}
