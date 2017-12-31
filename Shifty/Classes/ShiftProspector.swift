//
//  ShiftProspector.swift
//  Shifty
//
//  Created by William McGinty on 12/31/17.
//

import Foundation

struct ShiftProspector {
    
    struct Prospects {
        let sources: [Shiftable]
        let destinations: [Shiftable]
    }
    
    func prospectiveShifts(from source: ShiftTransitionable, to destination: ShiftTransitionable) -> Prospects {
        guard source.containsShiftables && destination.containsShiftables else { return Prospects(sources: [], destinations: []) }
        
        let sourceViews = flattenedHierarchy(for: source.shiftContentView, withExclusions: source.shiftExclusions)
        let destinationViews = flattenedHierarchy(for: destination.shiftContentView, withExclusions: destination.shiftExclusions)
        return Prospects(sources: sourceViews.flatMap { $0.shiftable }, destinations: destinationViews.flatMap { $0.shiftable })
    }
}

//MARK: Helper
private extension ShiftProspector {

    private func flattenedHierarchy(for view: UIView, withExclusions exclusions: [UIView]) -> [UIView] {
        guard !exclusions.contains(view) else { return [] }
        
        if view.isHidden {
            return []
        }
        
        return [view] + view.subviews.flatMap { flattenedHierarchy(for: $0, withExclusions: exclusions) }
    }
}
