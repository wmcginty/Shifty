//
//  ViewControllerB.swift
//  Shifty
//
//  Created by William McGinty on 7/6/16.
//  Copyright © 2016 Will McGinty. All rights reserved.
//

import UIKit
import Shifty

class CommitShiftExampleViewControllerB: UIViewController, ShiftTransitioning {
    
    @IBOutlet var yellowView: UIView!
    @IBOutlet var orangeView: UIView!
    @IBOutlet var backButton: UIButton!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yellowView.shiftID = .yellow
        orangeView.shiftID = .orange
        backButton.shiftTarget = Shift.Target(view: backButton, identifier: .button, replicationStrategy: .replication)
    }
    
    // MARK: IBActions
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
