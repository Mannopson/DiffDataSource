//
//  SimpleView.swift
//  DiffDataSource
//
//  Created by Abduaziz on 2/7/23.
//

import UIKit

class SimpleView: UICollectionReusableView {
    
    static let reuseIdentifier = "simple-supplementary-reuse-identifier"
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension SimpleView {
    func configure(with title: String) {
        titleLabel.text = title
    }
    
    private func viewSetup() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10)
        ])
    }
}
