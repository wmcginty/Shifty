//
//  ViewControllerA.swift
//  Shifty
//
//  Created by William McGinty on 7/6/16.
//  Copyright © 2016 Will McGinty. All rights reserved.
//

import UIKit
import Shifty

extension Shift.Identifier {
    static let yellow = Shift.Identifier(rawValue: "yellow")
    static let orange = Shift.Identifier(rawValue: "ornage")
}

class ShiftExampleViewControllerA: UIViewController, ShiftTransitionable {
    
    @IBOutlet var yellowView: UIView!
    @IBOutlet var orangeView: UIView!
    @IBOutlet var shiftButton: UIButton!
    private var shiftTransitioningManager = SimpleShiftTransitioningDelegate()
    
    private var animator: ShiftAnimator?
    private var animator2: UIViewPropertyAnimator?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
    }
    
    // MARK: IBActions
    @IBAction func shiftItButtonPressed(sender: AnyObject) {
        
        yellowView.shiftID = .yellow
        orangeView.shiftID = .orange
        shiftButton.actionModifier = Action.Modifier.translate(byX: 0, y: 50).fade(to: 0)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "ShiftExampleViewControllerB") as? ShiftExampleViewControllerB else { return }

        controller.modalPresentationStyle = .currentContext
        controller.transitioningDelegate = shiftTransitioningManager

        present(controller, animated: true, completion: nil)
    }
}
