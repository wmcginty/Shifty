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
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = navTransitioningDelegate
        definesPresentationContext = true
    }
    
    //MARK: IBActions
    @IBAction func shiftItButtonPressed(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewControllerB") as! ViewControllerB

        if let navController = navigationController {
            navController.pushViewController(controller, animated: true)
        } else {
            controller.modalPresentationStyle = .currentContext
            controller.otherTransitioningDelegate = frameShiftTransitioningDelegate
            
            present(controller, animated: true, completion: nil)
        }
    }
}

//MARK: ContinuityTransitionPreparable
extension ViewControllerA: ContinuityTransitionPreparable {
    func prepareForTransitionFrom(_ source: UIViewController) {
        shiftButton.transform = CGAffineTransform(translationX: 0, y: 200)
    }
}

//MARK: ContinuityTransitionable
extension ViewControllerA: ContinuityTransitionable {
    
    func prepareForTransition(to destination: UIViewController, withDuration duration: TimeInterval, completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.3, animations: {
            self.shiftButton.transform = CGAffineTransform(translationX: 0, y: 200)
        }) { (finished) in
            completion(finished)
        }
    }
    
    func completeTransition(from source: UIViewController) {
        UIView.animate(withDuration: 0.3) { 
            self.shiftButton.transform = CGAffineTransform.identity
        }
    }
}

//MARK: FrameShiftable
extension ViewControllerA: FrameShiftable {
    func shiftablesForTransition(with viewController: UIViewController) -> [Shiftable] {
        return [Shiftable(view: yellowView, identifier: "yellow"),
                Shiftable(view: orangeView, identifier: "orange"),
                Shiftable(view: titleLabel, identifier: "title")]
    }
}
