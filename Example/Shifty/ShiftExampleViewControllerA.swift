//
//  ViewControllerA.swift
//  Shifty
//
//  Created by William McGinty on 7/6/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Shifty

class ShiftExampleViewControllerA: UIViewController, ShiftTransitionable {
    
    @IBOutlet var yellowView: UIView!
    @IBOutlet var orangeView: UIView!
    @IBOutlet var shiftButton: UIButton!
    private var shiftTransitioningDelegate = SimpleShiftTransitioningDelegate()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        
        yellowView.shiftID = "yellow"
        orangeView.shiftID = "orange"
    }
    
    // MARK: IBActions
    @IBAction func shiftItButtonPressed(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ShiftExampleViewControllerB") as! ShiftExampleViewControllerB
        
        controller.modalPresentationStyle = .currentContext
        controller.transitioningDelegate = shiftTransitioningDelegate
        present(controller, animated: true, completion: nil)
    }
}

// MARK: TransitionRespondable
extension ShiftExampleViewControllerA: TransitionRespondable {
    
    func completeTransition(from source: TransitionRespondable?) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
            self.shiftButton.alpha = 1
        }, completion: nil)
    }
    
    func completeTransition(to destination: TransitionRespondable?) {
        shiftButton.alpha = 1
    }
    
    func prepareForTransition(from source: TransitionRespondable?) {
        shiftButton.alpha = 0
    }
    
    func prepareForTransition(to destination: TransitionRespondable?, withDuration duration: TimeInterval, completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
            self.shiftButton.alpha = 0
        }, completion: completion)
    }
}

