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
        
        yellowView.actionModifier = .translate(byX: -300, y: 0)
        orangeView.actionModifier = .translate(byX: -300, y: 0)
        yellowView2.actionModifier = .translate(byX: -300, y: 0)
        orangeView2.actionModifier = .translate(byX: -300, y: 0)
        
        shiftButton.actionModifier = Action.Modifier.scale(toX: 0.33, y: 0.33).fade(to: 0)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "ContinuousExampleViewControllerB") as? ContinuousExampleViewControllerB else { return }
        
        controller.modalPresentationStyle = .currentContext
        controller.transitioningDelegate = continuityTransitioningManager
        present(controller, animated: true, completion: nil)
    }
}
