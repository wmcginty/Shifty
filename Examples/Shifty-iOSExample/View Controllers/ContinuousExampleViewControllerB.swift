//
//  ViewControllerB.swift
//  Shifty
//
//  Created by William McGinty on 7/6/16.
//  Copyright © 2016 Will McGinty. All rights reserved.
//

import UIKit
import Shifty

class ContinuousExampleViewControllerB: UIViewController, ShiftTransitioning {
    
    @IBOutlet var yellowView: UIView!
    @IBOutlet var orangeView: UIView!
    @IBOutlet var yellowView2: UIView!
    @IBOutlet var orangeView2: UIView!
    
    @IBOutlet var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yellowView.actionModifier = .translate(byX: 300, y: 0)
        orangeView.actionModifier = .translate(byX: 300, y: 0)
        yellowView2.actionModifier = .translate(byX: 300, y: 0)
        orangeView2.actionModifier = .translate(byX: 300, y: 0)
        
        backButton.actionModifier = Action.Modifier.fade(to: 0).scale(toX: 0.33, y: 0.33)
    }
    
    // MARK: - IBActions
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
