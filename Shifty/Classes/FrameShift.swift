//
//  FrameShift.swift
//  Shifty
//
//  Created by William McGinty on 6/7/16.
//  Copyright © 2016 will.mcginty. All rights reserved.
//

import Foundation

/// Represents the frame shift of a single `UIView` object.
class FrameShift {
    
    //MARK: Properties
    
    /// The source state of the shift
    let source: Shiftable
    
    /// The destination state of the shift
    let destination: Shiftable
    fileprivate let destinationSnapshot: Snapshot?
    
    /// In flight shift
    var shiftingView: UIView?
    
    //MARK: Initializers
    init(source: Shiftable, destination: Shiftable, destinationSnapshot: Snapshot? = nil) {
        self.source = source
        self.destination = destination
        self.destinationSnapshot = destinationSnapshot
        
        assert(source.identifier == destination.identifier, "Source and Destination identifiers must match.")
    }
}

//MARK: Container Management
extension FrameShift {
    
    func setNativeViews(hidden: Bool) {
        source.view.isHidden = hidden
        destination.view.isHidden = hidden
    }
    
    func insertShiftingView(into container: UIView) {
        let view = source.viewForShiftWithRespect(to: container)
        container.addSubview(view)
        setNativeViews(hidden: true)
        
        shiftingView = view
    }
    
    func cleanup(finished: Bool) {
        setNativeViews(hidden: false)
        shiftingView?.removeFromSuperview()
    }
}

//MARK: Shift Actions
extension FrameShift {

    func finalSnapshot() -> Snapshot {
        return destinationSnapshot ?? destination.snapshot()
    }
    
    func shiftActionApplied(in container: UIView) -> ShiftAction {
        let animation = shiftApplied(in: container)
        let completion = cleanup
        
        return ShiftAction(animations: animation, completion: completion)
    }
    
    func performCustomShift(with destination: CustomFrameShiftable, in container: UIView, with duration: TimeInterval?, completion: AnimationCompletion? = nil) {
        guard let shiftView = shiftingView else { fatalError("Can not apply custom shift in container view (\(container)) before the shifting view has been created.") }
        destination.performShift(with: shiftView, in: container, forFinal: finalSnapshot(), with: duration) { finished in
            
            //Clean up after the shift transition
            self.cleanup(finished: finished)
            completion?(finished)
        }
    }
}

//MARK: Helper
fileprivate extension FrameShift {
    
    func shiftApplied(in container: UIView) -> () -> Void {
        guard let shiftView = shiftingView else { fatalError("Can not apply shift in container view (\(container)) before the shifting view has been created.") }
        
        let finalSnapshot = destinationSnapshot ?? destination.snapshot()
        return { finalSnapshot.applyPositionalState(to: shiftView, in: container) }
    }
}

//MARK: Equatable
extension FrameShift: Equatable {
    
    static func ==(lhs: FrameShift, rhs: FrameShift) -> Bool {
        return true
    }
}
