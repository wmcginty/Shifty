//
//  SnapshotTests.swift
//  Shifty-Tests
//
//  Created by William McGinty on 12/29/17.
//  Copyright © 2017 Will McGinty. All rights reserved.
//

import XCTest
@testable import Shifty

class SnapshotTests: XCTestCase {
    
    func testSnapshot_equalityDependsOnAllProperties() {
        let superview = UIView()
        let snap1 = Snapshot(center: .zero, bounds: .zero, alpha: 1, transform3D: CATransform3DIdentity, cornerRadius: 0, superview: superview)
        let snap2 = Snapshot(center: .zero, bounds: .zero, alpha: 1, transform3D: CATransform3DIdentity, cornerRadius: 0, superview: superview)
       
        XCTAssertEqual(snap1, snap2)
    }
    
    func testSnapshot_notEqualWhenCenterDiffers() {
        let superview = UIView()
        let snap1 = Snapshot(center: .zero, bounds: .zero, alpha: 1, transform3D: CATransform3DIdentity, cornerRadius: 0, superview: superview)
        let snap2 = Snapshot(center: CGPoint(x: 1, y: 1), bounds: .zero, alpha: 1, transform3D: CATransform3DIdentity, cornerRadius: 0, superview: superview)
        
        XCTAssertNotEqual(snap1, snap2)
    }
    
    func testSnapshot_notEqualWhenBoundsDiffers() {
        let superview = UIView()
        let snap1 = Snapshot(center: .zero, bounds: .zero, alpha: 1, transform3D: CATransform3DIdentity, cornerRadius: 0, superview: superview)
        let snap2 = Snapshot(center: .zero, bounds: CGRect(x: 0, y: 0, width: 100, height: 200), alpha: 1, transform3D: CATransform3DIdentity, cornerRadius: 0, superview: superview)
        
        XCTAssertNotEqual(snap1, snap2)
    }
    
    func testSnapshot_notEqualWhenAlphaDiffers() {
        let superview = UIView()
        let snap1 = Snapshot(center: .zero, bounds: .zero, alpha: 0.5, transform3D: CATransform3DIdentity, cornerRadius: 0, superview: superview)
        let snap2 = Snapshot(center: .zero, bounds: .zero, alpha: 1, transform3D: CATransform3DIdentity, cornerRadius: 0, superview: superview)
        
        XCTAssertNotEqual(snap1, snap2)
    }
    
    func testSnapshot_notEqualWhenBackgroundColorDiffers() {
        let superview = UIView()
        let snap1 = Snapshot(center: .zero, bounds: .zero, alpha: 1, backgroundColor: UIColor.white, transform3D: CATransform3DIdentity, cornerRadius: 0, superview: superview)
        let snap2 = Snapshot(center: .zero, bounds: .zero, alpha: 1, transform3D: CATransform3DIdentity, cornerRadius: 0, superview: superview)
        
        XCTAssertNotEqual(snap1, snap2)
    }
    
    func testSnapshot_notEqualWhenTransformDiffers() {
        let superview = UIView()
        let transform = CATransform3D(m11: 2, m12: 2, m13: 2, m14: 2, m21: 2, m22: 2, m23: 2, m24: 2,
                                      m31: 2, m32: 2, m33: 2, m34: 2, m41: 2, m42: 2, m43: 2, m44: 2)
        let snap1 = Snapshot(center: .zero, bounds: .zero, alpha: 1, transform3D: CATransform3DIdentity, cornerRadius: 0, superview: superview)
        let snap2 = Snapshot(center: .zero, bounds: .zero, alpha: 1, transform3D: transform, cornerRadius: 0, superview: superview)
        
        XCTAssertNotEqual(snap1, snap2)
    }
    
    func testSnapshot_notEqualWhenCornerRadiusDiffers() {
        let superview = UIView()
        let snap1 = Snapshot(center: .zero, bounds: .zero, alpha: 1, transform3D: CATransform3DIdentity, cornerRadius: 0, superview: superview)
        let snap2 = Snapshot(center: .zero, bounds: .zero, alpha: 1, transform3D: CATransform3DIdentity, cornerRadius: 4, superview: superview)
        
        XCTAssertNotEqual(snap1, snap2)
    }
    
    func testSnapshot_notEqualWhenSuperviewDiffers() {
        let snap1 = Snapshot(center: .zero, bounds: .zero, alpha: 1, transform3D: CATransform3DIdentity, cornerRadius: 0, superview: UIView())
        let snap2 = Snapshot(center: .zero, bounds: .zero, alpha: 1, transform3D: CATransform3DIdentity, cornerRadius: 0, superview: UIView())
        
        XCTAssertNotEqual(snap1, snap2)
    }
    
    func testSnapshot_initializationFromViewCorrectlyStoresProperties() {
        let center = CGPoint(x: 50, y: 50)
        let bounds = CGRect(origin: .zero, size: CGSize(width: 125, height: 50))
        let alpha: CGFloat = 0.75
        let backgroundColor = UIColor.red
        let transform = CATransform3D(m11: 1, m12: 2, m13: 3, m14: 4, m21: 1, m22: 2, m23: 3, m24: 4,
                                      m31: 1, m32: 2, m33: 3, m34: 4, m41: 1, m42: 2, m43: 3, m44: 4)
        let cornerRadius: CGFloat = 6
        let superview = UIView()
        
        let snap1 = Snapshot(center: center, bounds: bounds, alpha: alpha, backgroundColor: backgroundColor,
                             transform3D: transform, cornerRadius: cornerRadius, superview: superview)
        
        let view = UIView()
        superview.addSubview(view)
        view.center = center
        view.bounds = bounds
        view.alpha = alpha
        view.backgroundColor = backgroundColor
        view.layer.transform = transform
        view.layer.cornerRadius = cornerRadius
        
        let snap2 = Snapshot(view: view)
        XCTAssertEqual(snap1, snap2)
    }
    
    func testSnapshot_appliesVisualStateCorrectly() {
        let view = UIView()
        view.backgroundColor = .red
        view.alpha = 0.4
        view.layer.cornerRadius = 3
        let snap = snapshot(in: UIView())
        
        snap.applyVisualState(to: view)
        XCTAssertEqual(view.backgroundColor, snap.backgroundColor)
        XCTAssertEqual(view.alpha, snap.alpha, accuracy: 0.01)
        XCTAssertEqual(view.layer.cornerRadius, snap.cornerRadius)
    }
    
    func testSnapshot_calculatesCenterInViewCorrectly() {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let child = UIView(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
        container.addSubview(child)
        
        let native = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        child.addSubview(native)
        
        let snap = Snapshot(view: native)
        let center = snap.center(in: container)
        
        XCTAssertEqual(center.x, 62.5)
        XCTAssertEqual(center.y, 62.5)
        
        let center2 = snap.center(in: child)
        XCTAssertEqual(center2.x, 12.5)
        XCTAssertEqual(center2.y, 12.5)
    }
    
    func testSnapshot_appliesPositionalStateCorrectly() {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let child = UIView(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
        container.addSubview(child)
        
        let transform = CATransform3D(m11: 1, m12: 2, m13: 3, m14: 4, m21: 1, m22: 1, m23: 1, m24: 1, m31: 1, m32: 1, m33: 1, m34: 1, m41: 1, m42: 1, m43: 1, m44: 1)
        
        let native = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        native.layer.transform = transform
        child.addSubview(native)
        
        let snap = Snapshot(view: native)
        
        let replicant = UIView()
        container.addSubview(replicant)
        
        snap.applyPositionalState(to: replicant)
        
        XCTAssertEqual(replicant.center, CGPoint(x: 62.5, y: 62.5))
        XCTAssertEqual(replicant.bounds, CGRect(origin: .zero, size: CGSize(width: 25, height: 25)))
        XCTAssertEqual(replicant.layer.transform, transform)
    }
    
    // MARK: Helper
    private func snapshot(in superview: UIView) -> Snapshot {
        return Snapshot(center: CGPoint(x: 50, y: 50), bounds: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)),
                        alpha: 0.4, backgroundColor: .red, transform3D: CATransform3DIdentity, cornerRadius: 3, superview: superview)
    }
}
