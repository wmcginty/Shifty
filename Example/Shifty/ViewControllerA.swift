//
//  ViewControllerA.swift
//  Shifty
//
//  Created by William McGinty on 7/6/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Shifty

class ViewControllerA: UIViewController {
    
    @IBOutlet var yellowView: UIView!
    @IBOutlet var orangeView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var shiftButton: UIButton!
    
    var navTransitioningDelegate = NavTransitioningDelegate()
    var frameShiftTransitioningDelegate = SimpleTransitioningDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = navTransitioningDelegate
    }
    
    @IBAction func shiftItButtonPressed(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewControllerB")
        controller.transitioningDelegate = frameShiftTransitioningDelegate
        
        navigationController?.pushViewController(controller, animated: true)
        //present(controller, animated: true, completion: nil)
    }
}

extension ViewControllerA: ContinuityTransitionPreparable {
    func prepareForTransitionFrom(_ source: UIViewController) {
        shiftButton.transform = CGAffineTransform(translationX: 0, y: 200)
    }
}

extension ViewControllerA: ContinuityTransitionable {
    func prepareForTransitionTo(_ destination: UIViewController, with duration: TimeInterval, completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.3, animations: {
            self.shiftButton.transform = CGAffineTransform(translationX: 0, y: 200)
        }) { (finished) in
            completion(finished)
        }
    }
    
    func completeTransitionFrom(_ source: UIViewController) {
        UIView.animate(withDuration: 0.3) { 
            self.shiftButton.transform = CGAffineTransform.identity
        }
    }
}

extension ViewControllerA: FrameShiftable {
    func shiftablesForTransitionWith(_ viewController: UIViewController) -> [Shiftable] {
        //TODO: can we use the name of the ivar as a default identifier?
        return [Shiftable(view: yellowView, identifier: "yellow"),
                Shiftable(view: orangeView, identifier: "orange"),
                Shiftable(view: titleLabel, identifier: "title")]
    }
}
