//
//  ShiftAnimator.swift
//  Pods-Shifty_Example
//
//  Created by William McGinty on 12/26/17.
//

import Foundation

public class ShiftAnimator {
    
    public let source: FrameShiftTransitionable
    public let destination: FrameShiftTransitionable
    
    private let shifts: [Shift]
    private var destinations: [Shift: Snapshot]?
    private var baseAnimator: UIViewPropertyAnimator?
    private var animators: [Shift: UIViewPropertyAnimator] = [:]
    
    //MARK: Initializers
    public init(source: FrameShiftTransitionable, destination: FrameShiftTransitionable, coordinator: ShiftCoordinator = DefaultShiftCoordinator()) {
        self.source = source
        self.destination = destination
        self.shifts = coordinator.shifts(from: source.shiftablesForTransition(with: destination),
                                         to: destination.shiftablesForTransition(with: source))
    }
    
    public convenience init?(source: Any, destination: Any) {
        guard let s = source as? FrameShiftTransitionable, let d = destination as? FrameShiftTransitionable else { return nil }
        self.init(source: s, destination: d)
    }
    
    //MARK: Interface
    public func commitShifts() {
        let shiftDestinations = Dictionary(uniqueKeysWithValues: shifts.map { ($0, $0.destinationSnapshot() )})
        destinations = shiftDestinations
    }
    
    public func animate(with duration: TimeInterval, inContainer container: UIView, completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        commitDestinationsIfNeeded()
        shifts.forEach { shift in
            
            let animator = configuredAnimator(for: shift, duration: duration, timingParameters: shift.timingCurve, in: container)
            if let completion = completion, shift == shifts.first {
                animator.addCompletion(completion)
            }
            
            animator.startAnimation()
            animators[shift] = animator
        }
    }
}

//MARK: Shift Committing
private extension ShiftAnimator {
    
    var hasCommittedShifts: Bool { return destinations != nil }
    
    func commitDestinationsIfNeeded() {
        guard !hasCommittedShifts else { return }
        commitShifts()
    }
}

//MARK: Shift Animations
private extension ShiftAnimator {
        
    func configuredAnimator(for shift: Shift, duration: TimeInterval,
                            timingParameters: UITimingCurveProvider, in container: UIView) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: timingParameters)
        let snapshot = destinations?[shift]
        let shiftingView = shift.configuredShiftingView(in: container)
        
        animator.addAnimations { snapshot?.applyPositionalState(to: shiftingView, in: container) }
        animator.addCompletion { _ in shift.cleanupShiftingView(shiftingView) }
        
        return animator
    }
}
