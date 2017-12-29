//
//  ViewControllerB.swift
//  Shifty
//
//  Created by William McGinty on 7/6/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Shifty

class CommitShiftExampleViewControllerB: UIViewController {
    
    @IBOutlet var yellowView: UIView!
    @IBOutlet var orangeView: UIView!
    @IBOutlet var backButton: UIButton!
    
    // MARK: IBActions
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: TransitionRespondable
extension CommitShiftExampleViewControllerB: TransitionRespondable {
    func completeTransition(from source: TransitionRespondable?) { }
    func prepareForTransition(to destination: TransitionRespondable?, withDuration duration: TimeInterval, completion: @escaping (Bool) -> Void) {
        completion(true)
    }
}

// MARK: FrameShiftTransitionable
extension CommitShiftExampleViewControllerB: FrameShiftTransitionable {
    var shiftables: [Shiftable] {
        return [Shiftable(view: yellowView, identifier: "yellow"),
                Shiftable(view: orangeView, identifier: "orange")]
    }
}
