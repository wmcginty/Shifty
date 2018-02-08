//
//  ShiftAnimator.swift
//  Shifty
//
//  Created by William McGinty on 12/26/17.
//

import Foundation

/* TODO:
    -Allow 'entrance' animations to happen simultaneously with shifts. Possibly by moving all exit/entrance/shift animations to snapshots that are happening in front of the source/destination view hierarchies.
 */

public class ShiftAnimator: NSObject {
    
    private let shifts: [Shift]
    private var destinations: [Shift: Snapshot]?
    var animators: [Shift: UIViewPropertyAnimator] = [:]

    // MARK: Initializers
    public init(source: ShiftTransitionable, destination: ShiftTransitionable, coordinator: ShiftCoordinator = DefaultCoordinator()) {
        let prospects = Prospector().prospectiveShifts(from: source, to: destination)
        self.shifts = coordinator.shifts(from: prospects.sources, to: prospects.destinations)
    }
    
    public convenience init?(source: Any, destination: Any, coordinator: ShiftCoordinator = DefaultCoordinator()) {
        guard let s = source as? ShiftTransitionable, let d = destination as? ShiftTransitionable else { return nil }
        self.init(source: s, destination: d, coordinator: coordinator)
    }
    
    // MARK: Interface
    public func commitShifts() {
        let shiftDestinations = Dictionary(uniqueKeysWithValues: shifts.map { ($0, $0.destinationSnapshot() )})
        destinations = shiftDestinations
    }
    
    public func animate(withDuration duration: TimeInterval, inContainer container: UIView, completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        commitDestinationsIfNeeded()
        shifts.forEach { shift in
            
            let animator = configuredAnimator(for: shift, duration: duration, in: container)
            if let completion = completion, shift == shifts.first {
                animator.addCompletion(completion)
            }
            
            animator.startAnimation()
            animators[shift] = animator
        }
    }
}

// MARK: Shift Committing
private extension ShiftAnimator {
    
    func commitDestinationsIfNeeded() {
        guard destinations == nil else { return }
        commitShifts()
    }
}

// MARK: Shift Animations
private extension ShiftAnimator {
        
    func configuredAnimator(for shift: Shift, duration: TimeInterval, in container: UIView) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: shift.animationContext.timingParameters)
        let snapshot = destinations?[shift]
        let shiftingView = shift.configuredShiftingView(inContainer: container)
        
        animator.addAnimations { shift.shiftAnimations(for: shiftingView, in: container, target: snapshot) }
        animator.addCompletion { _ in shift.cleanupShiftingView(shiftingView) }
        
        return animator
    }
}
