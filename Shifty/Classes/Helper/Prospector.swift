//
//  Prospector.swift
//  Shifty
//
//  Created by William McGinty on 12/31/17.
//

import Foundation

struct Prospector {
    
    struct Prospects {
        let sources: [State]
        let destinations: [State]
    }
    
    func prospectiveShifts(from source: ShiftTransitionable, to destination: ShiftTransitionable) -> Prospects {
        guard source.isShiftingEnabled && destination.isShiftingEnabled else { return Prospects(sources: [], destinations: []) }
        
        let sourceViews = flattenedHierarchy(for: source.shiftContentView, withExclusions: source.shiftExclusions)
        let destinationViews = flattenedHierarchy(for: destination.shiftContentView, withExclusions: destination.shiftExclusions)
        return Prospects(sources: sourceViews.flatMap { $0.shiftState }, destinations: destinationViews.flatMap { $0.shiftState })
    }
}

// MARK: Helper
private extension Prospector {

    private func flattenedHierarchy(for view: UIView, withExclusions exclusions: [UIView]) -> [UIView] {
        guard !exclusions.contains(view), !view.isHidden else { return [] }
        return [view] + view.subviews.flatMap { flattenedHierarchy(for: $0, withExclusions: exclusions) }
    }
}
