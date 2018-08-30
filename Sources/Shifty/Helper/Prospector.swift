//
//  Prospector.swift
//  Shifty
//
//  Created by William McGinty on 12/31/17.
//

import Foundation

struct Prospector {
    
    struct ShiftProspects {
        let sources: [State]
        let destinations: [State]
    }
    
    static func prospectiveShifts(from source: ShiftTransitionable, to destination: ShiftTransitionable) -> ShiftProspects {
        guard source.isShiftingEnabled && destination.isShiftingEnabled else { return ShiftProspects(sources: [], destinations: []) }
        
        let sourceViews = flattenedHierarchy(for: source.shiftContentView, withExclusions: source.shiftExclusions)
        let destinationViews = flattenedHierarchy(for: destination.shiftContentView, withExclusions: destination.shiftExclusions)
        return ShiftProspects(sources: sourceViews.compactMap { $0.shiftState }, destinations: destinationViews.compactMap { $0.shiftState })
    }
    
    static func actionReference(from transitionable: ShiftTransitionable) -> [UIView: ActionGroup] {
        let views: [(UIView, ActionGroup)] = flattenedHierarchy(for: transitionable.shiftContentView, withExclusions: []).compactMap { view in
            return view.actions.map { (view, $0) } ?? nil
        }
        
       return Dictionary(views, uniquingKeysWith: { left, _ in left })
    }
}

// MARK: Helper
private extension Prospector {

    static func flattenedHierarchy(for view: UIView, withExclusions exclusions: [UIView]) -> [UIView] {
        guard !exclusions.contains(view), !view.isHidden else { return [] }
        return [view] + view.subviews.flatMap { flattenedHierarchy(for: $0, withExclusions: exclusions) }
    }
}
