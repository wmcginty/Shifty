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
    private var animators: [Shift: UIViewPropertyAnimator] = [:]

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
    
    public func animate(with duration: TimeInterval, inContainer container: UIView, completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
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
    
    var hasCommittedShifts: Bool { return destinations != nil }
    
    func commitDestinationsIfNeeded() {
        guard !hasCommittedShifts else { return }
        commitShifts()
    }
}

// MARK: Shift Animations
private extension ShiftAnimator {
        
    func configuredAnimator(for shift: Shift, duration: TimeInterval, in container: UIView) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: shift.animationContext.timingParameters)
        let snapshot = destinations?[shift]
        let shiftingView = shift.configuredShiftingView(in: container)
        
        animator.addAnimations { shift.shiftAnimations(for: shiftingView, in: container, target: snapshot) }
        animator.addCompletion { _ in shift.cleanupShiftingView(shiftingView) }
        
        return animator
    }
}

//MARK: UIViewImplicitlyAnimating
extension ShiftAnimator: UIViewImplicitlyAnimating {

    private var representativeAnimator: UIViewPropertyAnimator? {
        return animators.values.first
    }
    
    public var state: UIViewAnimatingState {
        return representativeAnimator?.state ?? .inactive
    }
    
    public var isRunning: Bool {
        return representativeAnimator?.isRunning ?? false
    }
    
    public var isReversed: Bool {
        get { return representativeAnimator?.isReversed ?? false }
        set {
            animators.values.forEach { $0.isReversed = newValue }
        }
    }
    
    public var fractionComplete: CGFloat {
        get { return representativeAnimator?.fractionComplete ?? 0 }
        set {
            animators.values.forEach { $0.fractionComplete = fractionComplete }
        }
    }
    
    public func startAnimation() {
        animators.values.forEach { $0.startAnimation() }
    }
    
    public func startAnimation(afterDelay delay: TimeInterval = 0.0) {
        animators.values.forEach { $0.startAnimation(afterDelay: delay) }
    }
    
    public func pauseAnimation() {
        animators.values.forEach { $0.pauseAnimation() }
    }
    
    public func stopAnimation(_ withoutFinishing: Bool) {
        animators.values.forEach { $0.stopAnimation(withoutFinishing) }
    }
    
    public func finishAnimation(at finalPosition: UIViewAnimatingPosition) {
        animators.values.forEach { $0.finishAnimation(at: finalPosition) }
    }
}
