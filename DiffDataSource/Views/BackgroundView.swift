//
//  BackgroundView.swift
//  DiffDataSource
//
//  Created by Abduaziz on 2/8/23.
//

import UIKit

class BackgroundView: UICollectionReusableView {
    
    static let reuseIdentifier = "background-supplementary-reuse-identifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemCyan
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
