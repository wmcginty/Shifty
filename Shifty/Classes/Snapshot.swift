//
//  Snapshot.swift
//  ShiftKit
//
//  Created by William McGinty on 6/3/16.
//  Copyright © 2016 will.mcginty. All rights reserved.
//

import Foundation

public struct Snapshot {
    
    let center: CGPoint
    let bounds: CGRect
    let transform: CGAffineTransform
    let transform3d: CATransform3D
    
    init(view: UIView) {
        center = view.center
        bounds = view.bounds
        transform = view.transform
        transform3d = view.layer.transform
    }
    
    func centerOf(_ view: UIView, withRespectTo containerView: UIView) -> CGPoint {
        return containerView.convert(center, from: view.superview)
    }
    
    func applyPositionalStateTo(_ newView: UIView, in containerView: UIView) {
        newView.bounds = bounds
        newView.center = centerOf(newView, withRespectTo: containerView)
        newView.transform = transform
        newView.layer.transform = transform3d
    }
}
