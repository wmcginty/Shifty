//
//  ViewControllerA.swift
//  Shifty
//
//  Created by William McGinty on 7/6/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
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
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "ContinuousExampleViewControllerB") as? ContinuousExampleViewControllerB else { return }
        
        controller.modalPresentationStyle = .currentContext
        controller.transitioningDelegate = continuityTransitioningManager
        present(controller, animated: true, completion: nil)
        
        yellowView.actions = [.translate(byX: -200, y: 0)].delayed(by: 0.0)
        orangeView.actions = [.translate(byX: -200, y: 0)].delayed(by: 0.1)
        yellowView2.actions = [.translate(byX: -200, y: 0)].delayed(by: 0.2)
        orangeView2.actions = [.translate(byX: -200, y: 0)].delayed(by: 0.3)
    }
}

// MARK: TransitionRespondable
//extension ContinuousExampleViewControllerA: TransitionRespondable {
//
//    func animatingViews() -> [UIView] {
//        return [yellowView, orangeView, yellowView2, orangeView2, shiftButton]
//    }
//
//    func completeTransition(from source: TransitionRespondable?) {
//        for (idx, view) in animatingViews().enumerated() {
//            let delay = Double(idx) * 0.05
//            UIView.animate(withDuration: 0.3, delay: delay, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
//                view.transform = .identity
//            }, completion: nil)
//        }
//    }
//
//    func completeTransition(to destination: TransitionRespondable?) {
//        animatingViews().forEach { $0.transform = .identity }
//    }
//
//    func prepareForTransition(from source: TransitionRespondable?) {
//        animatingViews().forEach { $0.transform = CGAffineTransform(translationX: -self.view.bounds.width, y: 0) }
//    }
//
//    func prepareForTransition(to destination: TransitionRespondable?, withDuration duration: TimeInterval, completion: @escaping (Bool) -> Void) {
//        for (idx, view) in animatingViews().enumerated() {
//            let delay = Double(idx) * 0.05
//            UIView.animate(withDuration: duration - delay, delay: delay, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
//                view.transform = CGAffineTransform(translationX: -self.view.bounds.width, y: 0)
//            }, completion: { finished in
//                if idx == self.animatingViews().endIndex - 1 {
//                    completion(finished)
//                }
//            })
//        }
//    }
//}

