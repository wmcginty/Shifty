//
//  ViewControllerB.swift
//  Shifty
//
//  Created by William McGinty on 7/6/16.
//  Copyright © 2016 Will McGinty. All rights reserved.
//

import UIKit
import Shifty

class CommitShiftExampleViewControllerB: UIViewController, ShiftTransitionable {
    
    @IBOutlet var yellowView: UIView!
    @IBOutlet var orangeView: UIView!
    @IBOutlet var backButton: UIButton!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        yellowView.shiftID = "yellow"
//        orangeView.shiftID = "orange"
//        backButton.actions = [.fade(to: 0)]
    }
    
    // MARK: IBActions
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
