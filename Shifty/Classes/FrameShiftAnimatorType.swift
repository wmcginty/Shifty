//
//  FrameShiftAnimatorType.swift
//  Pods
//
//  Created by William McGinty on 7/6/16.
//
//

import UIKit

public protocol FrameShiftAnimatorType {
    
    /// The source object, conforms to `FrameShiftable`.
    var source: FrameShiftable { get }
    
    /// The destination object, conforms to `FrameShiftable`.
    var destination: FrameShiftable { get }
    
    /**
     Initialize an animator with a pre-determined source and destination.
     
     - parameter source: The source of the shift.
     - parameter destination: The destination of the shift.
     - parameter deferSnapshotting: A boolean value indicating when view snapshotting will take place. A value of true means that the positional state of the view at it's destination will be determined just in time. A value of value means that these state's will be determined at initialization time.
     */
    init(source: FrameShiftable, destination: FrameShiftable, deferSnapshotting: Bool)
    
    /**
     Perform the frame shifting animation inside the container.
     
     - parameter containerView: The view which contains the transition. This view will be used as the shiftingView's superview.
     - parameter destinationView: The destination view of the transition. This view will be laid out before shifts are completed.
     - parameter duration: An optional duration for the shift. If this value is `nil` the shift will take place over a default duration (0.3s).
     */
    func performFrameShiftAnimations(in containerView: UIView, with destinationView: UIView, over duration: TimeInterval?)
}

//TODO: I think this would work better as a inheritance tree PropertyAnimator: Animator (the code reuse would be better)
//TODO: Complete the property frame shift animator
//TODO: Add a transitional animation from source/destination view to the shifting view, customizable.
//TODO: Add transitional state properties (color, image, etc)

extension FrameShiftAnimatorType {
    
    static var defaultAnimationDuration: TimeInterval { return 0.3 }
    
    func insert(_ shiftingView: UIView, into containerView: UIView, for shift: FrameShift) {
        containerView.addSubview(shiftingView)
        shift.initial.view.isHidden = true
        shift.final.view.isHidden = true
    }
    
    func performAnimationCleanup(for shiftingView: UIView, shift: FrameShift) {
        shift.initial.view.isHidden = false
        shift.final.view.isHidden = false
        shiftingView.removeFromSuperview()
    }
    
    func configuredSnapshotsFor(_ states: [Shiftable]) -> [Shiftable: Snapshot] {
        return states.toDictionary(){ ($0, $0.snapshot()) }
    }
}
