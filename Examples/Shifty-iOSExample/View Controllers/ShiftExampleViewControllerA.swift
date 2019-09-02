//
//  ViewControllerA.swift
//  Shifty
//
//  Created by William McGinty on 7/6/16.
//  Copyright © 2016 Will McGinty. All rights reserved.
//

import UIKit
import Shifty

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
        
        orangeView.isHidden = true
        orangeView.layer.cornerRadius = 16
    }
    
    // MARK: IBActions
    @IBAction func shiftItButtonPressed(sender: AnyObject) {
        
//        if animator2 == nil {
//            animator2 = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations: {
//                UIView.animateKeyframes(withDuration: 0.0, delay: 0.0, options: [], animations: {
//                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.75, animations: {
//                        self.yellowView.alpha = 0.5
//                    })
//                }, completion: nil)
//            })
//            animator2?.pausesOnCompletion = true
//            animator2?.startAnimation()
//
//        } else {
//            animator2?.isReversed.toggle()
//                        animator2?.continueAnimation(withTimingParameters: nil, durationFactor: 1)
//            //animator2?.startAnimation()
//        }
    
        let source = Shift.Target(view: yellowView, identifier: .init(rawValue: "1"), replicationStrategy: .replication)
        let dest = Shift.Target(view: orangeView, identifier: .init(rawValue: "1"), replicationStrategy: .replication)

        var shift = Shift(source: source, destination: dest)
        shift.nativeViewRestorationBehavior = .destination

        if animator == nil {
            animator = ShiftAnimator(timingProvider: CubicTimingProvider(duration: 1.0, curve: .easeInOut))
            animator?.pausesOnCompletion = true
            animator?.animate(shift, in: view) { position in
                debugPrint(position.rawValue)
            }
        } else {
            animator?.isReversed.toggle()
            animator?.startAnimation()
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
