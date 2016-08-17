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
    
    @IBOutlet var yellowView: UIView!
    @IBOutlet var orangeView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    }
    
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}

extension ViewControllerB: ContinuityTransitionPreparable {
    func prepareForTransitionFrom(_ source: UIViewController) {
        backButton.transform = CGAffineTransform(translationX: 0, y: 200)
    }
}

extension ViewControllerB: ContinuityTransitionable {
    func prepareForTransitionTo(_ destination: UIViewController, with duration: TimeInterval, completion: (Bool) -> Void) {
        UIView.animate(withDuration: 0.3, animations: { 
            self.backButton.transform = CGAffineTransform(translationX: 0, y: 200)
            }) { (finished) in
                completion(finished)
        }
    }
    
    func completeTransitionFrom(_ source: UIViewController) {
        UIView.animate(withDuration: 0.3) {
            self.backButton.transform = CGAffineTransform.identity
        }
    }
}

extension ViewControllerB: FrameShiftable {
    func shiftablesForTransitionWith(_ viewController: UIViewController) -> [Shiftable] {
        return [Shiftable(view: yellowView, identifier: "yellow"),
                Shiftable(view: orangeView, identifier: "orange"),
                Shiftable(view: titleLabel, identifier: "title")]
    }
}
