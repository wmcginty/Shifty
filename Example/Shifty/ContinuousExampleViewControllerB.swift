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
        
        yellowView.actions = [.translate(byX: 200, y: 0)].with(delayFactor: 0.0)
        orangeView.actions = [.translate(byX: 200, y: 0)].with(delayFactor: 0.1)
        yellowView2.actions = [.translate(byX: 200, y: 0)].with(delayFactor: 0.2)
        orangeView2.actions = [.translate(byX: 200, y: 0)].with(delayFactor: 0.3)
    }
    
    // MARK: IBActions
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
