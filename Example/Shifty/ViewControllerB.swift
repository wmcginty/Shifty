//
//  ViewControllerB.swift
//  Shifty
//
//  Created by William McGinty on 7/6/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Shifty

class ViewControllerB: UIViewController {
    
    public var otherTransitioningDelegate: UIViewControllerTransitioningDelegate? {
        didSet { transitioningDelegate = otherTransitioningDelegate } //Have to retain that transitioning delegate for modal transitions, ;)
    }
    
    @IBOutlet var yellowView: UIView!
    @IBOutlet var orangeView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    }
    
    //MARK: IBActions
    @IBAction func dismiss() {
        if let navController = navigationController {
            let _ = navController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: ContinuityTransitionPreparable
extension ViewControllerB: ContinuityTransitionPreparable {
    func prepareForTransition(from source: UIViewController) {
        backButton.transform = CGAffineTransform(translationX: 0, y: 200)
    }
}

//MARK: ContinuityTransitionable
extension ViewControllerB: ContinuityTransitionable {
    func prepareForTransition(to destination: UIViewController, withDuration duration: TimeInterval, completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.3, animations: { 
            self.backButton.transform = CGAffineTransform(translationX: 0, y: 200)
            }) { (finished) in
                completion(finished)
        }
    }
    
    func completeTransition(from source: UIViewController) {
        UIView.animate(withDuration: 0.3) {
            self.backButton.transform = CGAffineTransform.identity
        }
    }
}

//MARK: FrameShiftable
extension ViewControllerB: FrameShiftable {
    func shiftablesForTransition(with viewController: UIViewController) -> [Shiftable] {
        return [Shiftable(view: yellowView, identifier: "yellow"),
                Shiftable(view: orangeView, identifier: "orange"),
                Shiftable(view: titleLabel, identifier: "title")]
    }
}
