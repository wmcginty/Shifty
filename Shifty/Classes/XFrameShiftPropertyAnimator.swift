
//  FrameShiftPropertyAnimator.swift
//  Shifty
//
//  Created by William McGinty on 7/6/16.
//
//

/*import Foundation

@available(iOS 10.0, *)
public class XFrameShiftPropertyAnimator: FrameShiftAnimator {
    
    //MARK: Public Properties
    public let propertyAnimator: UIViewPropertyAnimator
    
    //MARK: Initializers
    public init(source: FrameShiftable, destination: FrameShiftable, animator: UIViewPropertyAnimator, deferSnapshotting: Bool = true) {
        
        propertyAnimator = animator
        super.init(source: source, destination: destination, deferSnapshotting: deferSnapshotting)
    }
    
    override func addDefaultAnimations(for frameShift: FrameShift, shiftingView: UIView, inContainer container: UIView, toFinal snapshot: Snapshot?) {
        
        let singleShift = frameShift.shiftApplied(to: shiftingView, in: container, withFinal: snapshot)
        propertyAnimator.addAnimations(singleShift)
        
        let singleCompletion = cleanup(for: shiftingView, shift: frameShift)
        propertyAnimator.addCompletion { position in
            singleCompletion(position == .start || position == .end)
        }
    }
    
    override func performShiftAnimations(_ animations: @escaping ShiftAnimations, over duration: TimeInterval?, completion: ShiftAnimationCompletion?) {
        propertyAnimator.addCompletion { (position) in
            completion?(position == .start || position == .end)
        }
        
        propertyAnimator.startAnimation()
    }
}

//MARK: Private Helpers
@available(iOS 10.0, *)
fileprivate extension FrameShiftPropertyAnimator {
    }
*/
