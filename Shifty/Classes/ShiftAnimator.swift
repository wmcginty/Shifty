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
    private var shiftDestinations: [Shift: Snapshot]?
    private var animator: UIViewPropertyAnimator?
    
    //MARK: Initializers
    public init(source: FrameShiftTransitionable, destination: FrameShiftTransitionable) {
        self.source = source
        self.destination = destination
        self.shifts = ShiftAnimator.shifts(from: source.shiftablesForTransition(with: destination),
                                           with: destination.shiftablesForTransition(with: source))
    }
    
    public convenience init?(source: UIViewController, destination: UIViewController) {
        guard let s = source as? FrameShiftTransitionable, let d = destination as? FrameShiftTransitionable else { return nil }
        self.init(source: s, destination: d)
    }
    
    //MARK: Interface
    public func commitShifts() {
        let destinations = Dictionary(uniqueKeysWithValues: shifts.map { ($0, $0.destinationSnapshot() )})
        shiftDestinations = destinations
    }
    
    public func animate(with duration: TimeInterval, timingCurve: UITimingCurveProvider,
                        inContainer container: UIView,
                        completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        
        animator = UIViewPropertyAnimator(duration: duration, timingParameters: timingCurve)
        completion.map { animator?.addCompletion($0) }

        if shiftDestinations == nil { commitShifts() }
        shifts.forEach { configureAnimation(for: $0, with: animator, in: container) }
        animator?.startAnimation()
    }
}

//MARK: Helper
private extension ShiftAnimator {
    
    static func shifts(from sources: [Shiftable], with destinations: [Shiftable]) -> [Shift] {
        return sources.flatMap { source in
            guard let match = destinations.first(where: { $0.identifier == source.identifier }) else { return nil }
            return Shift(source: source, destination: match)
        }
    }
    
    func configureAnimation(for shift: Shift, with animator: UIViewPropertyAnimator?, in container: UIView) {
        let snapshot = shiftDestinations?[shift]
        let shiftingView = shift.configuredShiftingView(in: container)
        
        animator?.addAnimations { snapshot?.applyPositionalState(to: shiftingView, in: container) }
        animator?.addCompletion { _ in shift.cleanupShiftingView(shiftingView) }
    }
    
    var hasCommittedShifts: Bool {
        return shiftDestinations != nil
    }
}
