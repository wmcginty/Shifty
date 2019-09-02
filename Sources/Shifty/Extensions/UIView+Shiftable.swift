//
//  UIView+State.swift
//  Shifty
//
//  Created by William McGinty on 12/31/17.
//

import Foundation

// MARK: UIView + Target
extension UIView {
    private struct AssociatedKeys {
        static var shiftID = "shiftID"
        static var actions = "actions"
    }
    
    /** The shift identifier for this `UIView`. If this identifier matches the identifier for another `UIView` in the destination of a
     transition, Shifty can animate the view from it's source position to it's destination position. This property simply creates a
     default 'Target' object and assigns it to the view's `shiftTarget` property. */
    public var shiftID: Shift.Identifier? {
        get { return shiftTarget?.identifier }
        set {
            guard let shiftID = newValue else { return }
            shiftTarget = Shift.Target(view: self, identifier: shiftID)
        }
    }
    
    /** The shift state object associated with this `UIView`. Contains the information necessary for the animator to create and execute
     the transition from it's position and state in the source to that in the destination. */
    public var shiftTarget: Shift.Target? {
        get { return getAssociatedObject(associatedKey: &AssociatedKeys.shiftID) }
        set {
            guard let target = newValue else { return }
            setAssociatedObject(target, associatedKey: &AssociatedKeys.shiftID, policy: .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
//    public var actions: ActionGroup? {
//        get { return getAssociatedObject(associatedKey: &AssociatedKeys.actions) }
//        set {
//            guard let actions = newValue else { return }
//            setAssociatedObject(actions, associatedKey: &AssociatedKeys.actions, policy: .OBJC_ASSOCIATION_RETAIN)
//            shiftState = nil
//        }
//    }
}

// MARK: NSObject + Associated Values
private extension NSObject {
    final private class AssociatedBox<T> {
        let value: T
        init(_ val: T) { value = val }
    }
    
    func setAssociatedObject<T>(_ object: T, associatedKey: UnsafeRawPointer, policy: objc_AssociationPolicy) {
        objc_setAssociatedObject(self, associatedKey, AssociatedBox(object), policy)
    }
    
    func getAssociatedObject<T>(associatedKey: UnsafeRawPointer) -> T? {
        return (objc_getAssociatedObject(self, associatedKey) as? AssociatedBox<T>)?.value
    }
}
