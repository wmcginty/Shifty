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
    
    //MARK: Private Properties
    fileprivate let frameShifts: [FrameShift]
    fileprivate var destinationSnapshots: [Shiftable: Snapshot]?
    
    fileprivate var shiftAnimations: ShiftAnimations?
    fileprivate var shiftCompletions: ShiftAnimationCompletion?

    //MARK: Initializers
    public required init(source: FrameShiftable, destination: FrameShiftable, deferSnapshotting: Bool = true) {
        
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
    public func performFrameShiftAnimations(inContainer containerView: UIView, withDestination destinationView: UIView, over duration: TimeInterval?, completion: ShiftAnimationCompletion? = nil) {
        assert(Thread.isMainThread, "Frame Shift Animation must be called from the main thread")
        
        //Force layout pass on destinationView so final shift positions are accurate
        destinationView.layoutIfNeeded()
        
        //Configure our individual animation and completion blocks and compose them together
        frameShifts.forEach { frameShift in
            
            let initial = frameShift.initial
            let final = frameShift.final
            
            //Create a copy of the sourceView according to initialState
            let shiftingView = initial.viewForShiftWithRespect(to: containerView)
            insert(shiftingView, into: containerView, for: frameShift)

            let singleShift = frameShift.shiftApplied(to: shiftingView, in: containerView, withFinal: destinationSnapshots?[final])
            shiftAnimations = add(singleShift, to: shiftAnimations)
            
            let singleCompletion = cleanup(for: shiftingView, shift: frameShift)
            shiftCompletions = add(singleCompletion, to: shiftCompletions)
        }
        
        if let completion = completion {
            shiftCompletions = add(completion, to: shiftCompletions)
        }
        
        performDefaultShiftAnimations(shiftAnimations ?? { _ in }, withDuration: duration, completion: shiftCompletions)
    }
}

//MARK: Animation and Completion
fileprivate extension FrameShiftAnimator {
    
    func performDefaultShiftAnimations(_ animations: @escaping ShiftAnimations, withDuration duration: TimeInterval?, completion: ShiftAnimationCompletion?) {
        UIView.animate(withDuration: duration ?? FrameShiftAnimator.defaultAnimationDuration, delay: 0.0, options: [.beginFromCurrentState],
                       animations: animations, completion: completion)
    }
    
    //FIXME: Don't like this here - global func? hope for closure extensions?
    private typealias VoidFunc = () -> Void
    func add(_ block: @escaping VoidFunc, to: VoidFunc?) -> VoidFunc {
        let current = to
        
        return {
            current?()
            block()
        }
    }
    
    private typealias BoolFunc = (Bool) -> Void
    func add(_ block: @escaping BoolFunc, to: BoolFunc?) -> BoolFunc {
        let current = to
        
        return { bool in
            current?(bool)
            block(bool)
        }
    }
}
