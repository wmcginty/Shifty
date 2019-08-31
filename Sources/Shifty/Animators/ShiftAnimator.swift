//
//  ShiftAnimator.swift
//  Shifty
//
//  Created by William McGinty on 8/31/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

open class ShiftAnimator: NSObject {
    
    // MARK: Properties
    public let timingProvider: TimingProvider
    public private(set) var shift: Shift
    public private(set) var destination: Snapshot?
    
    public var isDebugEnabled: Bool = false
    
    private var shiftAnimator: UIViewPropertyAnimator?
    
    // MARK: Initializers
    public init(shift: Shift, timingProvider: TimingProvider) {
        self.shift = shift
        self.timingProvider = timingProvider
    }
 
    // MARK: Interface
    open func commit() {
        destination = shift.destinationSnapshot()
    }
    
    public func animate(in container: UIView, completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        commitIfNeeded()
        assert(destination != nil, "ShiftAnimator [\(self)] could not commit a destination snapshot for shifting.")
        
        let animator = shiftAnimator(in: container, completion: completion)
        animator.startAnimation()
        shiftAnimator = animator
    }
}

// MARK: Helper
extension ShiftAnimator {
    
    func commitIfNeeded() {
        if destination == nil {
            commit()
        }
    }
    
    func shiftAnimator(in container: UIView, completion: ((UIViewAnimatingPosition) -> Void)? = nil) -> UIViewPropertyAnimator {
        let currentShift = isDebugEnabled ? shift.debug : shift
        let animator = UIViewPropertyAnimator(duration: timingProvider.duration, timingParameters: timingProvider.parameters)
        let replicant = currentShift.configuredReplicant(in: container)
        
        currentShift.layoutDestinationIfNeeded()
        
        animator.addAnimations {
            currentShift.shift(for: replicant)
        }
        
        animator.addCompletion { position in
            guard position != .current else {
                debugPrint("Shifty Warning: The shift animation did not end at either the start or end position. Abandoning automatic cleanup.")
                completion?(position); return
            }
            
            currentShift.cleanup(replicant: replicant)
            completion?(position)
        }
        
        return animator
    }
}
