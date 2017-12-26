//
//  ViewControllerB.swift
//  Shifty
//
//  Created by William McGinty on 7/6/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Shifty

class ShiftExampleViewControllerB: UIViewController {
    
    @IBOutlet var yellowView: UIView!
    @IBOutlet var orangeView: UIView!
    @IBOutlet var backButton: UIButton!
    
    //MARK: IBActions
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: TransitionRespondable
extension ShiftExampleViewControllerB: TransitionRespondable {
    
    func completeTransition(from source: TransitionRespondable?) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
            self.backButton.alpha = 1
        }, completion: nil)
    }
    
    func completeTransition(to destination: TransitionRespondable?) {
        backButton.alpha = 1
    }
    
    func prepareForTransition(from source: TransitionRespondable?) {
        backButton.alpha = 0
    }
    
    func prepareForTransition(to destination: TransitionRespondable?, withDuration duration: TimeInterval, completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
            self.backButton.alpha = 0
        }, completion: completion)
    }
}

//MARK: FrameShiftTransitionable
extension ShiftExampleViewControllerB: FrameShiftTransitionable {
    func shiftablesForTransition(with transitionable: FrameShiftTransitionable) -> [Shiftable] {
        return [Shiftable(view: yellowView, identifier: "yellow"),
                Shiftable(view: orangeView, identifier: "orange")]
    }
}



