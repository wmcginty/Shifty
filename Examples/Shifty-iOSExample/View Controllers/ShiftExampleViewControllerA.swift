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
    private var shiftTransitioningManager = SimpleShiftTransitioningDelegate()
    
    private var animator: ShiftAnimator?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
    }
    
    // MARK: IBActions
    @IBAction func shiftItButtonPressed(sender: AnyObject) {
        
        let source = Shift.Target(view: yellowView, identifier: .init(rawValue: "1"), replicationStrategy: .replication)
        let dest = Shift.Target(view: orangeView, identifier: .init(rawValue: "1"), replicationStrategy: .replication)
        
        var shift = Shift(source: source, destination: dest)
        shift.nativeViewRestorationBehavior = .destination
        
        animator = ShiftAnimator(shift: shift, timingProvider: CubicTimingProvider(duration: 1.0, curve: .easeInOut))
        animator?.animate(in: view) { position in
            print(position)
        }
        
        
//        yellowView.shiftID = "yellow"
//        orangeView.shiftID = "orange"
//        shiftButton.actions = [.translate(byX: 0, y: 50), .fade(to: 0)]
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let controller = storyboard.instantiateViewController(withIdentifier: "ShiftExampleViewControllerB") as? ShiftExampleViewControllerB else { return }
//
//        controller.modalPresentationStyle = .currentContext
//        controller.transitioningDelegate = shiftTransitioningManager
//
//        present(controller, animated: true, completion: nil)
    }
}
