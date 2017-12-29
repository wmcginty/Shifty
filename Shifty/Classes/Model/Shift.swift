//
//  Shift.swift
//  Shifty
//
//  Created by William McGinty on 12/25/17.
//

import Foundation

/// Represents the frame shift of a single `UIView` object.
public struct Shift: Hashable {
    
    //MARK: Properties
    public let source: Shiftable
    public let destination: Shiftable
    public let timingCurve: UITimingCurveProvider
    
    //MARK: Hashable
    public var hashValue: Int {
        return source.hashValue ^ destination.hashValue
    }
    
    public static func ==(lhs: Shift, rhs: Shift) -> Bool {
        return lhs.source == rhs.source && lhs.destination == rhs.destination
    }
}

//MARK: Container Management
extension Shift {
    
    func configuredShiftingView(in container: UIView) -> UIView {
        
        //Create, add and place the shiftingView with respect to the container
        let shiftingView = source.viewForShiftWithRespect(to: container)
        container.addSubview(shiftingView)
        source.applyPositionalState(to: shiftingView, in: container)
        
        //Configure the native views as hidden so the shiftingView is the only visible copy, then return it
        configureNativeViews(hidden: true)
        return shiftingView
    }
    
    func cleanupShiftingView(_ shiftingView: UIView) {
        configureNativeViews(hidden: false)
        shiftingView.removeFromSuperview()
    }
}

//MARK: Snapshots
extension Shift {
    
    func destinationSnapshot() -> Snapshot {
        return destination.currentSnapshot()
    }
}

//MARK: Helper
private extension Shift {
    
    func configureNativeViews(hidden: Bool) {
        [source.view, destination.view].forEach { $0.isHidden = hidden }
    }
}


