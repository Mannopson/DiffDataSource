//
//  ViewControllerExtension.swift
//  DiffDataSource
//
//  Created by Abduaziz on 2/7/23.
//

import Foundation
import UIKit

extension ViewController {
    func viewSetup() {
        view.backgroundColor = .systemBackground
        
        configureHierarchy()
        configureDataSource()
        snapshot()
    }
}

// MARK: - CELL CONFIGURATION
extension ViewController {
    fileprivate func configure(using cell: UICollectionViewListCell, indexPath: IndexPath) {
        guard let item = self.dataSource.itemIdentifier(for: indexPath) else { return }
        guard let section = self.dataSource.snapshot().sectionIdentifier(containingItem: item) else { return }
        switch section.kind {
        case .grid: grid(using: cell, indexPath: indexPath)
        case .page: page(using: cell, indexPath: indexPath)
        case .more: grid(using: cell, indexPath: indexPath)
        }
    }
    
    private func grid(using cell: UICollectionViewListCell, indexPath: IndexPath) {
        var contentConfiguration = UIListContentConfiguration.valueCell()
        contentConfiguration.textProperties.alignment = .center
        contentConfiguration.text = indexPath.row.description
        cell.contentConfiguration = contentConfiguration
    }
    
    private func page(using cell: UICollectionViewListCell, indexPath: IndexPath) {
        var contentConfiguration = UIListContentConfiguration.valueCell()
        contentConfiguration.textProperties.alignment = .center
        contentConfiguration.text = indexPath.row == 0 ? "22,702,450 so'm" : "0 so'm"
        cell.contentConfiguration = contentConfiguration
    }
}

// MARK: - DATA SOURCE
extension ViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemGroupedBackground
        view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        let layout = UICollectionViewCompositionalLayout.init(sectionProvider: { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let section = self.dataSource.sectionIdentifier(for: sectionIndex) else { return nil }
            switch section.kind {
            case .grid: return self.gridTypeSection()
            case .page: return self.pageTypeSection(sectionIndex: sectionIndex)
            case .more: return self.moreTypeSection()
            }
        }, configuration: config)
        layout.register(BackgroundView.self, forDecorationViewOfKind: decorationViewOfKind)
        return layout
    }
    
    func gridTypeSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalWidth(0.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(60))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       repeatingSubitem: item,
                                                       count: 2)
        let spacing = CGFloat(2)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                        leading: 10,
                                                        bottom: 10,
                                                        trailing: 10)
        section.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: decorationViewOfKind)]
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(30))
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem.init(layoutSize: footerSize,
                                                                             elementKind: ViewController.simpleFooterElementKind,
                                                                             alignment: .bottom)
        section.boundarySupplementaryItems = [sectionFooter]
        return section
    }
    
    func pageTypeSection(sectionIndex: Int) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(60))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       repeatingSubitem: item,
                                                       count: 1)
        let spacing = CGFloat(2)
        group.interItemSpacing = .fixed(spacing)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                        leading: 10,
                                                        bottom: 10,
                                                        trailing: 10)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(20))
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem.init(layoutSize: footerSize,
                                                                             elementKind: ViewController.sectionFooterElementKind,
                                                                             alignment: .bottom)
        section.boundarySupplementaryItems = [sectionFooter]
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, scrollOffset, layoutEnvironment in
            // Perform animations on the visible items.
            guard let self = self else { return }
            let page = round(scrollOffset.x / self.view.bounds.width)
            self.pagingInfoSubject.send(Page(section: sectionIndex, current: Int(page)))
        }
        return section
    }
    
    func moreTypeSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalWidth(0.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(60))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       repeatingSubitem: item,
                                                       count: 2)
        let spacing = CGFloat(2)
        group.interItemSpacing = .fixed(spacing)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                        leading: 10,
                                                        bottom: 10,
                                                        trailing: 10)
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(30))
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem.init(layoutSize: footerSize,
                                                                             elementKind: ViewController.simpleFooterElementKind,
                                                                             alignment: .bottom)
        section.boundarySupplementaryItems = [sectionFooter]
        return section
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Int> { (cell, indexPath, item) in
            self.configure(using: cell, indexPath: indexPath)
        }
        
        dataSource = UICollectionViewDiffableDataSource<SectionKind, Int>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        let footerRegistration = UICollectionView.SupplementaryRegistration
        <FooterView>(elementKind: ViewController.sectionFooterElementKind) { [unowned self]
            (supplementaryView, string, indexPath) in
            guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
            guard let sectionKind = dataSource.snapshot().sectionIdentifier(containingItem: item) else { return }
            if sectionKind.kind == .page {
                let pageCount = dataSource.snapshot().numberOfItems(inSection: sectionKind)
                supplementaryView.configure(with: pageCount)
                supplementaryView.subscribeTo(subject: pagingInfoSubject, for: indexPath.section)
            }
        }
        
        let simpleRegistration = UICollectionView.SupplementaryRegistration
        <SimpleView>(elementKind: ViewController.simpleFooterElementKind) { [unowned self]
            (supplementaryView, string, indexPath) in
            guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
            guard let section = dataSource.snapshot().sectionIdentifier(containingItem: item) else { return }
            if section.kind == .grid {
                supplementaryView.configure(with: "Top section footer with the text.")
            }
            if section.kind == .more {
                supplementaryView.configure(with: "Bottom section footer with the text.")
            }
        }

        dataSource.supplementaryViewProvider = { (view, kind, indexPath) in
            switch kind {
            case ViewController.sectionFooterElementKind: return self.collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: indexPath)
            case ViewController.simpleFooterElementKind: return self.collectionView.dequeueConfiguredReusableSupplementary(using: simpleRegistration, for: indexPath)
            default: return nil
            }
        }
    }
}

// MARK: - SNAPSHOT
extension ViewController {
    private func snapshot() {
        let grid = SectionKind.init(header: "", footer: "", kind: .grid)
        let page = SectionKind.init(header: "", footer: "", kind: .page)
        let more = SectionKind.init(header: "", footer: "", kind: .more)
        var snapshot = NSDiffableDataSourceSnapshot<SectionKind, Int>()
        snapshot.appendSections([grid, page, more])
        snapshot.appendItems(Array(0..<4), toSection: grid)
        snapshot.appendItems(Array(5..<7), toSection: page)
        snapshot.appendItems(Array(8..<10), toSection: more)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
