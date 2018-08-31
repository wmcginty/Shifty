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
    
    // MARK: Properties
    private let shifts: [Shift]
    private var destinations: [Shift: Snapshot]?
    
    //We use multiple property animators to allow each Shift to occur on a different timing curve. This also means we can support different overall durations and delays using keyframes inside the individual `TimingContext`s.
    private(set) var animators: [Shift: UIViewPropertyAnimator] = [:]

    // MARK: Initializers
    public convenience init?(source: ShiftTransitionable, destination: ShiftTransitionable, timingContext: TimingContext = CubicAnimationContext.default) {
        self.init(source: source, destination: destination, coordinator: DefaultCoordinator(animationContext: timingContext))
    }
    
    public init?(source: ShiftTransitionable, destination: ShiftTransitionable, coordinator: ShiftCoordinator) {
        let prospects = Prospector.prospectiveShifts(from: source, to: destination)
        let shifts = coordinator.shifts(from: prospects.sources, to: prospects.destinations)
        guard !shifts.isEmpty else { return nil }
        
        self.shifts = shifts
    }
    
    // MARK: Interface
    public func commitShifts() {
        let shiftDestinations = Dictionary(uniqueKeysWithValues: shifts.map { ($0, $0.destinationSnapshot() )})
        destinations = shiftDestinations
    }
    
    public func animate(withDuration duration: TimeInterval, inContainer container: UIView, completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        commitDestinationsIfNeeded()
        assert(!shifts.isEmpty, "The ShiftAnimator should not be created with an empty [Shift].")
        
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

// MARK: Helper
private extension ShiftAnimator {
    
    func commitDestinationsIfNeeded() {
        guard destinations == nil else { return }
        commitShifts()
    }
    
    func configuredAnimator(for shift: Shift, duration: TimeInterval, in container: UIView) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: shift.timingContext.timingParameters)
        let snapshot = destinations?[shift]
        let shiftingView = shift.configuredShiftingView(inContainer: container)
        
        animator.addAnimations { shift.shiftAnimations(for: shiftingView, in: container, target: snapshot) }
        animator.addCompletion { _ in shift.cleanupShiftingView(shiftingView) }
        
        return animator
    }
}
