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
    static let button = Shift.Identifier(rawValue: "button")
}

class CommitShiftExampleViewControllerA: UIViewController, ShiftTransitioning {
    
    @IBOutlet var yellowView: UIView!
    @IBOutlet var orangeView: UIView!
    @IBOutlet var shiftButton: UIButton!
    private var shiftTransitioningManager = PrecommitShiftTransitioningDelegate()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
    }
    
    // MARK: - IBActions
    @IBAction func shiftItButtonPressed(sender: AnyObject) {
        
        yellowView.shiftID = .yellow
        orangeView.shiftID = .orange
        shiftButton.shiftTarget = Shift.Target(view: shiftButton, identifier: .button, replicationStrategy: .replication) { replicant, target, _ in
            if let repButton = replicant as? UIButton, let tarButton = target.view as? UIButton {
                repButton.setTitle(tarButton.title(for: .normal), for: .normal)
            }
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "CommitShiftExampleViewControllerB") as? CommitShiftExampleViewControllerB else { return }
        
        controller.modalPresentationStyle = .currentContext
        controller.transitioningDelegate = shiftTransitioningManager
        present(controller, animated: true, completion: nil)
    }
}
