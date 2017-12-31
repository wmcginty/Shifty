//
//  UIView+Shiftable.swift
//  Shifty
//
//  Created by William McGinty on 12/31/17.
//

import Foundation

//MARK: UIView + Shiftable
public extension UIView {
    private struct AssociatedKeys {
        static var shiftID    = "shiftID"
    }
    
    /// The shift identifier for this view. If this identifier matches the identifier of another view during a transition. Shifty can animate that view from it's source to it's destination. This propert simply creates a default `Shiftable` object and assigns it to the view's `shiftable` property.
    public var shiftID: AnyHashable? {
        get { return shiftable?.identifier }
        set {
            guard let shiftID = newValue else { return }
            shiftable = Shiftable(view: self, identifier: shiftID)
        }
    }
    
    /// The shiftable object associated with this view. Contains the necessary information for the shift animator to conduct the transition from this view's position to it's matching destination view position.
    public var shiftable: Shiftable? {
        get { return getAssociatedObject(associatedKey: &AssociatedKeys.shiftID) }
        set {
            guard let shiftable = newValue else { return }
            setAssociatedObject(shiftable, associatedKey: &AssociatedKeys.shiftID, policy: .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

//MARK: NSObject + Associated Values
extension NSObject {
    final private class AssociatedBox<T> {
        let value: T
        init(_ v: T) { value = v }
    }
    
    func setAssociatedObject<T>(_ object: T, associatedKey: UnsafeRawPointer, policy: objc_AssociationPolicy) {
        objc_setAssociatedObject(self, associatedKey, AssociatedBox(object), policy)
    }
    
    func getAssociatedObject<T>(associatedKey: UnsafeRawPointer) -> T? {
        return (objc_getAssociatedObject(self, associatedKey) as? AssociatedBox<T>)?.value
    }
}


