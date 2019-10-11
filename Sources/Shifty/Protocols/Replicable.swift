//
//  Replicable.swift
//  Shifty-iOS
//
//  Created by William McGinty on 8/31/19.
//  Copyright © 2019 Will McGinty. All rights reserved.
//

import Foundation

public protocol Replicable {
    var replicant: UIView { get }
}

// MARK: UIView + Replicable
extension UIView: Replicable {
    
    @objc open var replicant: UIView {
        let replicant = UIView(frame: bounds)
        replicant.backgroundColor = backgroundColor
        replicant.layer.cornerRadius = layer.cornerRadius
        replicant.layer.maskedCorners = layer.maskedCorners
        replicant.alpha = alpha
        
        return replicant
    }
}

// MARK: UIImageView + Replicable
extension UIImageView {
    
    @objc open override var replicant: UIView {
        let replicant = UIImageView(frame: bounds)
        replicant.image = image
        replicant.contentMode = contentMode
        replicant.alpha = alpha
        replicant.backgroundColor = backgroundColor
        replicant.layer.cornerRadius = layer.cornerRadius
        replicant.layer.maskedCorners = layer.maskedCorners
        
        return replicant
    }
}

// MARK: UIButton + Replicable
extension UIButton {
    
    @objc open override var replicant: UIView {
        let replicant = UIButton(type: buttonType)
        replicant.setTitle(title(for: .normal), for: .normal)
        replicant.titleLabel?.font = titleLabel?.font
        replicant.titleLabel?.textAlignment = titleLabel?.textAlignment ?? .left
        
        replicant.alpha = alpha
        replicant.backgroundColor = backgroundColor
        replicant.layer.cornerRadius = layer.cornerRadius
        replicant.layer.maskedCorners = layer.maskedCorners
        
        return replicant
    }
}

// MARK: UILabel + Replicable
extension UILabel {

    @objc open override var replicant: UIView {
        let replicant = UILabel(frame: bounds)
        replicant.text = text
        replicant.textColor = textColor
        replicant.textAlignment = textAlignment
        replicant.font = font
        replicant.alpha = alpha
        replicant.backgroundColor = backgroundColor
        replicant.layer.cornerRadius = layer.cornerRadius
        replicant.layer.maskedCorners = layer.maskedCorners
        replicant.lineBreakMode = lineBreakMode
        replicant.shadowColor = shadowColor
        replicant.shadowOffset = shadowOffset
        
        return replicant
    }
}
