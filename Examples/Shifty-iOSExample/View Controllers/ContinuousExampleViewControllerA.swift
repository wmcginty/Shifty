//
//  ViewControllerA.swift
//  Shifty
//
//  Created by William McGinty on 7/6/16.
//  Copyright © 2016 Will McGinty. All rights reserved.
//

import UIKit
import Shifty

class ContinuousExampleViewControllerA: UIViewController, ShiftTransitionable {
    
    @IBOutlet var yellowView: UIView!
    @IBOutlet var orangeView: UIView!
    @IBOutlet var yellowView2: UIView!
    @IBOutlet var orangeView2: UIView!
    
    @IBOutlet var shiftButton: UIButton!
    private var continuityTransitioningManager = ContinuityTransitioningDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
    }
        
    // MARK: IBActions
    @IBAction func shiftItButtonPressed(sender: AnyObject) {
        
//        yellowView.actions = [.translate(byX: -300, y: 0)].modifying(delayFactor: 0.0)
//        orangeView.actions = [.translate(byX: -300, y: 0)].modifying(delayFactor: 0.1)
//        yellowView2.actions = [.translate(byX: -300, y: 0)].modifying(delayFactor: 0.2)
//        orangeView2.actions = [.translate(byX: -300, y: 0)].modifying(delayFactor: 0.3)
        
//        shiftButton.actions = [.fade(to: 0), .scale(toX: 0.33, y: 0.33)].modifying(timingContext: SpringAnimationContext(timingParameters: UISpringTimingParameters(dampingRatio: 0.8)))
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "ContinuousExampleViewControllerB") as? ContinuousExampleViewControllerB else { return }
        
        controller.modalPresentationStyle = .currentContext
        controller.transitioningDelegate = continuityTransitioningManager
        present(controller, animated: true, completion: nil)
    }
}
