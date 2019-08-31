//
//  ViewControllerB.swift
//  Shifty
//
//  Created by William McGinty on 7/6/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Shifty

class ContinuousExampleViewControllerB: UIViewController, ShiftTransitionable {
    
    @IBOutlet var yellowView: UIView!
    @IBOutlet var orangeView: UIView!
    @IBOutlet var yellowView2: UIView!
    @IBOutlet var orangeView2: UIView!
    
    @IBOutlet var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        yellowView.actions = [.translate(byX: 200, y: 0)].modifying(delayFactor: 0.0)
//        orangeView.actions = [.translate(byX: 200, y: 0)].modifying(delayFactor: 0.1)
//        yellowView2.actions = [.translate(byX: 200, y: 0)].modifying(delayFactor: 0.2)
//        orangeView2.actions = [.translate(byX: 200, y: 0)].modifying(delayFactor: 0.3)
//        
       // backButton.actions = [.fade(to: 0), .scale(toX: 0.33, y: 0.33)].modifying(timingContext: SpringAnimationContext(timingParameters: UISpringTimingParameters(dampingRatio: 0.8)))
    }
    
    // MARK: IBActions
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
