//
//  SnapshotView.swift
//  Shifty
//
//  Created by William McGinty on 12/31/17.
//

import UIKit

class SnapshotView: UIView {
    
    // MARK: - Properties
    let contentView: UIView
    
    // MARK: - Initializers
    init(contentView: UIView) {
        self.contentView = contentView
        super.init(frame: contentView.frame)
        
        addSubview(contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds
    }
}
