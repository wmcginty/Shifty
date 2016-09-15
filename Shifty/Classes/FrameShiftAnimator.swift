//
//  FrameShiftAnimator.swift
//  Shifty
//
//  Created by William McGinty on 9/13/16.
//
//

import Foundation

public class FrameShiftAnimator {
    
    //MARK: Public Properties
    let shiftSource: FrameShiftable
    let shiftDestination: FrameShiftable
    
    //MARK: Internal Properties
    let frameShifts: [FrameShift]
    
    let defaultShift = CoalescedShift()
    var isCustomShiftable: Bool { return shiftDestination is CustomFrameShiftable }
    
    //MARK: Initializers
    public init(source: FrameShiftable, destination: FrameShiftable, deferSnapshotting: Bool = true) {
        
        let sources = source.shiftablesForTransition(with: destination.viewController)
        let destinations = destination.shiftablesForTransition(with: source.viewController)
        let reference = destinations.toDictionary { ($0.identifier, $0) }
        
        shiftSource = source
        shiftDestination = destination
        frameShifts = sources.flatMap() {
            guard let destination = reference[$0.identifier] else { return nil }
            return FrameShift(source: $0, destination: destination, destinationSnapshot: !deferSnapshotting ? destination.snapshot() : nil)
        }
    }
    
    //MARK: Public
    public func performShift(inContainer container: UIView, withDestination destination: UIView, with duration: TimeInterval?, completion: AnimationCompletion? = nil) {
        assert(Thread.isMainThread, "Frame Shift Animation must be called from the main thread")
        
        //Force layout pass on destinationView so final shift positions are accurate
        destination.layoutIfNeeded()
        
        //Configure our individual animation and completion blocks and compose them together
        frameShifts.forEach { frameShift in
            
            frameShift.insertShiftingView(into: container)
            
            //If destination conforms to CustomFrameShiftable - hand over to it
            if let customDestination = shiftDestination as? CustomFrameShiftable {
                
                performCustomShift(for: frameShift, to: customDestination, in: container, with: duration) { finished in
                    
                    //If this is the last shift, add the overall completion
                    if let lastShift = self.frameShifts.last, lastShift == frameShift, let completion = completion {
                        completion(finished)
                    }
                }
            } else {
                
                //Destination does not conform to CustomFrameShiftable - apply defaults
                addDefaultAnimations(for: frameShift, inContainer: container)
            }
        }
        
        performDefaultAnimationsIfNeeded(over: duration, completion: completion)
    }
}

//MARK: Default Shift
fileprivate extension FrameShiftAnimator {
    
    func addDefaultAnimations(for frameShift: FrameShift, inContainer container: UIView) {
        defaultShift.coalesce(frameShift.shiftActionApplied(in: container))
    }
    
    func performDefaultAnimationsIfNeeded(over duration: TimeInterval?, completion: AnimationCompletion? = nil) {
        guard !isCustomShiftable else { return }
        defaultShift.performShift(withDuration: duration ?? 0.3, completion: completion)
    }
}

//MARK: Custom Shift
fileprivate extension FrameShiftAnimator {
    
    func performCustomShift(for frameShift: FrameShift, to destination: CustomFrameShiftable, in container: UIView, with duration: TimeInterval?, completion: AnimationCompletion? = nil) {
        frameShift.performCustomShift(with: destination, in: container, with: duration, completion: completion)
    }
}
