//
//  ViewController.swift
//  DiffDataSource
//
//  Created by Abduaziz on 2/7/23.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    typealias SectionKind = Section
    
    static let simpleFooterElementKind = SimpleView.reuseIdentifier
    static let sectionFooterElementKind = FooterView.reuseIdentifier
    let decorationViewOfKind = BackgroundView.reuseIdentifier
    
    var dataSource: UICollectionViewDiffableDataSource<SectionKind, Int>! = nil
    var collectionView: UICollectionView! = nil
    
    let pagingInfoSubject = PassthroughSubject<Page, Never>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewSetup()
    }
}

