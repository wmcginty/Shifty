//
//  FrameShiftPropertyAnimator.swift
//  Shifty
//
//  Created by William McGinty on 9/13/16.
//
//

import Foundation

@available(iOS 10, *)
public class FrameShiftPropertyAnimator {
    
    //MARK: Public Properties
    let shiftSource: FrameShiftable
    let shiftDestination: FrameShiftable
    
    //MARK: Internal Properties
    let frameShifts: [FrameShift]
    let defaultAnimator: UIViewPropertyAnimator
    
    var isCustomShiftable: Bool { return shiftDestination is CustomFrameShiftable }
    
    //MARK: Initializers
    public init(source: FrameShiftable, destination: FrameShiftable, animator: UIViewPropertyAnimator, deferSnapshotting: Bool = true) {
        
        let sources = source.shiftablesForTransition(with: destination.viewController)
        let destinations = destination.shiftablesForTransition(with: source.viewController)
        let reference = destinations.toDictionary { ($0.identifier, $0) }
        
        shiftSource = source
        shiftDestination = destination
        defaultAnimator = animator
        frameShifts = sources.flatMap() {
            guard let destination = reference[$0.identifier] else { return nil }
            return FrameShift(source: $0, destination: destination, destinationSnapshot: !deferSnapshotting ? destination.snapshot() : nil)
        }
    }
    
    //MARK: Public
    public func performShift(inContainer container: UIView, withDestination destination: UIView, completion: AnimationCompletion? = nil) {
        assert(Thread.isMainThread, "Frame Shift Animation must be called from the main thread")
        
        //Force layout pass on destinationView so final shift positions are accurate
        destination.layoutIfNeeded()
        
        //Configure our individual animation and completion blocks and compose them together
        frameShifts.forEach { frameShift in
            
            frameShift.insertShiftingView(into: container)
            
            //If destination conforms to CustomFrameShiftable - hand over to it
            if let customDestination = shiftDestination as? CustomFrameShiftable {
                
                performCustomShift(for: frameShift, to: customDestination, in: container, with: defaultAnimator.duration) { finished in
                    
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
        
        performDefaultAnimationsIfNeeded(completion: completion)
    }
}

//MARK: Default Shift
@available(iOS 10, *)
fileprivate extension FrameShiftPropertyAnimator {
    
    func addDefaultAnimations(for frameShift: FrameShift, inContainer container: UIView) {
        let shiftAction = frameShift.shiftActionApplied(in: container)
        defaultAnimator.add(shiftAction)
    }
    
    func performDefaultAnimationsIfNeeded(completion: AnimationCompletion? = nil) {
        guard !isCustomShiftable else { return }
        defaultAnimator.add(completion)
        defaultAnimator.startAnimation()
    }
}

//MARK: Custom Shift
@available(iOS 10, *)
fileprivate extension FrameShiftPropertyAnimator {
    
    func performCustomShift(for frameShift: FrameShift, to destination: CustomFrameShiftable, in container: UIView, with duration: TimeInterval?, completion: AnimationCompletion? = nil) {
        frameShift.performCustomShift(with: destination, in: container, with: duration, completion: completion)
    }
}
