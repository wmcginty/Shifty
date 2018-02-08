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
    
    func prospectiveShifts(from source: ShiftTransitionable, to destination: ShiftTransitionable) -> ShiftProspects {
        guard source.isShiftingEnabled && destination.isShiftingEnabled else { return ShiftProspects(sources: [], destinations: []) }
        
        let sourceViews = flattenedHierarchy(for: source.shiftContentView, withExclusions: source.shiftExclusions)
        let destinationViews = flattenedHierarchy(for: destination.shiftContentView, withExclusions: destination.shiftExclusions)
        return ShiftProspects(sources: sourceViews.flatMap { $0.shiftState }, destinations: destinationViews.flatMap { $0.shiftState })
    }
    
    func actionReference(from transitionable: ShiftTransitionable) -> [UIView: ActionGroup] {
        let views: [(UIView, ActionGroup)] = flattenedHierarchy(for: transitionable.shiftContentView, withExclusions: []).flatMap { view in
            return view.actions.map { (view, $0) } ?? nil
        }
        
       return Dictionary(views, uniquingKeysWith: { l,r in l })
    }
}

// MARK: Helper
private extension Prospector {

    private func flattenedHierarchy(for view: UIView, withExclusions exclusions: [UIView]) -> [UIView] {
        guard !exclusions.contains(view), !view.isHidden else { return [] }
        return [view] + view.subviews.flatMap { flattenedHierarchy(for: $0, withExclusions: exclusions) }
    }
}
