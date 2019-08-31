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
    var shiftAnimator: UIViewPropertyAnimator
    
    public var isDebugEnabled: Bool = false
    
    // MARK: Initializers
    public init(shift: Shift, timingProvider: TimingProvider) {
        self.shift = shift
        self.timingProvider = timingProvider
        self.shiftAnimator = UIViewPropertyAnimator(duration: timingProvider.duration, timingParameters: timingProvider.parameters)
    }
 
    // MARK: Interface
    open func commit() {
        destination = shift.destinationSnapshot()
    }
    
    public func animate(in container: UIView, completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        commitIfNeeded()
        assert(destination != nil, "ShiftAnimator [\(self)] could not commit a destination snapshot for shifting.")
        
        configureShiftAnimations(in: container, completion: completion)
        startAnimation()
    }
    
    func configureShiftAnimations(in container: UIView, completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        let currentShift = isDebugEnabled ? shift.debug : shift
        let replicant = currentShift.configuredReplicant(in: container)
        currentShift.layoutDestinationIfNeeded()
        
        shiftAnimator.addAnimations {
            currentShift.shift(for: replicant)
        }
        
        shiftAnimator.addCompletion { position in
            guard position != .current else {
                debugPrint("Shifty Warning: The shift animation did not end at either the start or end position. Abandoning automatic cleanup.")
                completion?(position); return
            }
            
            currentShift.cleanup(replicant: replicant)
            completion?(position)
        }
    }
}

// MARK: Helper
extension ShiftAnimator {
    
    func commitIfNeeded() {
        if destination == nil {
            commit()
        }
    }
}
