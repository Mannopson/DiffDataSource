//
//  FooterView.swift
//  DiffDataSource
//
//  Created by Abduaziz on 2/7/23.
//

import UIKit
import Combine

class FooterView: UICollectionReusableView {
    
    static let reuseIdentifier = "footer-supplementary-reuse-identifier"
    var pagingInfoToken: AnyCancellable?
    
    lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.isUserInteractionEnabled = true
        control.currentPageIndicatorTintColor = .systemOrange
        control.pageIndicatorTintColor = .systemGray5
        return control
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        pagingInfoToken?.cancel()
        pagingInfoToken = nil
    }
}

extension FooterView {
    func configure(with numberOfPages: Int) {
        pageControl.numberOfPages = numberOfPages
    }
    func subscribeTo(subject: PassthroughSubject<Page, Never>, for section: Int) {
        pagingInfoToken = subject
            .filter { $0.section == section }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] page in
                self?.pageControl.currentPage = page.current
            }
    }
    func viewSetup() {
        backgroundColor = .clear
        pageControl.numberOfPages = 2
        addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
