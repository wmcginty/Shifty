//
//  FrameShiftAnimator.swift
//  Shifty
//
//  Created by Will McGinty on 4/28/16.
//  Copyright © 2016 will.mcginty. All rights reserved.
//

import UIKit

/// The animator object that handles the coordination of frame shifts from a source to a destination.
public class FrameShiftAnimator: FrameShiftAnimatorType {
    
    //MARK: Public Properties
    public let source: FrameShiftable
    public let destination: FrameShiftable
    
    //MARK: Internal Properties
    let frameShifts: [FrameShift]
    var destinationSnapshots: [Shiftable: Snapshot]?

    var shiftAnimations: ShiftAnimations?
    var shiftCompletions: ShiftAnimationCompletion?
    
    var usingDefaultShift: Bool { return !(destination is CustomFrameShiftable) }

    //MARK: Initializers
    public init(source: FrameShiftable, destination: FrameShiftable, deferSnapshotting: Bool = true) {
        
        let initialStates = source.shiftablesForTransition(with: destination.viewController)
        let finalStates = destination.shiftablesForTransition(with: source.viewController)
        let finalReference = finalStates.toDictionary { ($0.identifier, $0) }
        
        self.source = source
        self.destination = destination
        self.frameShifts = initialStates.flatMap() {
            guard let finalState = finalReference[$0.identifier] else { return nil }
            return FrameShift(initialState: $0, finalState: finalState)
        }
        
        if !deferSnapshotting {
            destinationSnapshots = configuredSnapshots(for: finalStates)
        }
    }
    
    //MARK: FrameShiftAnimatorType
    public func performShiftAnimations(inContainer container: UIView, withDestination dest: UIView, over duration: TimeInterval?, completion: ShiftAnimationCompletion? = nil) {
        assert(Thread.isMainThread, "Frame Shift Animation must be called from the main thread")
        
        //Force layout pass on destinationView so final shift positions are accurate
        dest.layoutIfNeeded()
        
        //Configure our individual animation and completion blocks and compose them together
        frameShifts.forEach { frameShift in
            
            let final = frameShift.final
            
            //Create a copy of the sourceView according to initialState
            let shiftingView = frameShift.initial.viewForShiftWithRespect(to: container)
            insert(shiftingView, into: container, for: frameShift)
            
            //If destination conforms to CustomFrameShiftable - hand over to it
            if let destination = destination as? CustomFrameShiftable {
                
                let finalSnapshot = destinationSnapshots?[final] ?? final.snapshot()
                performCustomShift(for: frameShift, to: destination, byShifting: shiftingView, to: finalSnapshot, over: duration, inContainer: container) { finished in
                    
                    //If this is the last shift, add the overall completion
                    if let lastShift = self.frameShifts.last, lastShift == frameShift, let completion = completion {
                        completion(finished)
                    }
                }
                
            } else {
                //Destination does not conform to CustomFrameShiftable - apply defaults
                addDefaultAnimations(for: frameShift, shiftingView: shiftingView, inContainer: container, toFinal: destinationSnapshots?[final])
            }
        }
        
        //If using default animations - trigger them now
        performDefaultAnimationsIfNeeded(over: duration, completion: completion)
    }
    
    func performShiftAnimations(_ animations: @escaping ShiftAnimations, over duration: TimeInterval?, completion: ShiftAnimationCompletion?) {
        UIView.animate(withDuration: duration ?? FrameShiftAnimator.defaultAnimationDuration, delay: 0.0, options: [.beginFromCurrentState],
                       animations: animations, completion: completion)
    }
    
    func addDefaultAnimations(for frameShift: FrameShift, shiftingView: UIView, inContainer container: UIView, toFinal snapshot: Snapshot?) {
        
        let singleShift = frameShift.shiftApplied(to: shiftingView, in: container, withFinal: snapshot)
        shiftAnimations = add(singleShift, to: shiftAnimations)
        
        let singleCompletion = cleanup(for: shiftingView, shift: frameShift)
        shiftCompletions = add(singleCompletion, to: shiftCompletions)
    }
}

//MARK: Default Shifting
extension FrameShiftAnimator {
    
    func performDefaultAnimationsIfNeeded(over duration: TimeInterval?, completion: ShiftAnimationCompletion?) {
        guard usingDefaultShift else { return }
        
        if let completion = completion {
            shiftCompletions = add(completion, to: shiftCompletions)
        }
        
        performShiftAnimations(shiftAnimations ?? { _ in }, over: duration, completion: shiftCompletions)
    }
}

//MARK: Custom Shifting
extension FrameShiftAnimator {
    
    func performCustomShift(for frameShift: FrameShift, to destination: CustomFrameShiftable, byShifting shifting: UIView, to snapshot: Snapshot, over duration: TimeInterval?, inContainer container: UIView, completion: ShiftAnimationCompletion? = nil) {
        destination.performShift(with: shifting, in: container, withFinal: snapshot, over: duration) { finished in
            
            //Clean up after the shift transition
            let clean = self.cleanup(for: shifting, shift: frameShift)
            clean(finished)
            
            completion?(finished)
        }
    }
}

fileprivate extension FrameShiftAnimator {

    //FIXME: Don't like this here - global func? hope for closure extensions?
    
    fileprivate typealias VoidFunc = () -> Void
    func add(_ block: @escaping VoidFunc, to: VoidFunc?) -> VoidFunc {
        let current = to
        
        return {
            current?()
            block()
        }
    }
    
    fileprivate typealias BoolFunc = (Bool) -> Void
    func add(_ block: @escaping BoolFunc, to: BoolFunc?) -> BoolFunc {
        let current = to
        
        return { bool in
            current?(bool)
            block(bool)
        }
    }
}
