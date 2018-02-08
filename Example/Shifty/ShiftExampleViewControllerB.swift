//
//  ViewControllerB.swift
//  Shifty
//
//  Created by William McGinty on 7/6/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Shifty

class ShiftExampleViewControllerB: UIViewController, ShiftTransitionable {
    
    @IBOutlet var yellowView: UIView!
    @IBOutlet var orangeView: UIView!
    @IBOutlet var backButton: UIButton!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yellowView.shiftID = "yellow"
        orangeView.shiftID = "orange"
    }
    
    // MARK: IBActions
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: TransitionRespondable
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
