//
//  MainViewController.swift
//  Combine & CollectionView Sample App
//
//  Created by Ali Bahadori on 13.01.21.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - typealiases
    
    typealias DataSource = UICollectionViewDiffableDataSource<SectionViewModel, TodoCellViewModel>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<SectionViewModel, TodoCellViewModel>
    
    // MARK: - Properties
    
    static let sectionHeaderElementKind = "section-header-element-kind"
    var viewModel: MainViewModel!
    private var collectionView: UICollectionView!
    private var dataSource: DataSource!
    private var snapshot: DataSourceSnapshot!
    
    //MARK: - View Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Main"
        configureCollectionViewLayout()
        configureCollectionViewDataSource()
        configureCallbacks()
        viewModel.fetchData()
    }
}

extension MainViewController {
    
    //MARK: - Collection View Setups
    
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 4,
            leading: 4,
            bottom: 4,
            trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.7),
            heightDimension: .absolute(140))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize:
            groupSize,
            subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: MainViewController.sectionHeaderElementKind,
            alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 8,
            bottom: 8,
            trailing: 8)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [sectionHeader]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func configureCollectionViewLayout() {
        
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(
            UINib(nibName: "TodoCell", bundle: nil),
            forCellWithReuseIdentifier: TodoCell.reuseIdentifier)
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: MainViewController.sectionHeaderElementKind,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        view.addSubview(collectionView)
    }
    
    private func configureCollectionViewDataSource() {
        
        dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, cellViewModel) -> TodoCell? in
                
            guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TodoCell.reuseIdentifier,
                    for: indexPath) as? TodoCell else { fatalError("Cannot create header view") }
            cell.viewModel = cellViewModel
                
            return cell
        })
        
        dataSource.supplementaryViewProvider = { [weak self] (
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in
            
            guard let self = self else { return nil }
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                    for: indexPath) as? SectionHeaderView else { fatalError("Cannot create header view") }
            let userName = self.viewModel.sectionViewModels[indexPath.section].userName
            supplementaryView.update(with: userName)
            return supplementaryView
        }
    }
    
    private func applySnapshot(viewModels: [SectionViewModel]) {
        
        snapshot = DataSourceSnapshot()
        snapshot.appendSections(viewModels)
        
        for viewModel in viewModels{
            snapshot.appendItems(viewModel.todos, toSection: viewModel)
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    //MARK: - Configure Callbacks
    
    private func configureCallbacks(){
        
        viewModel.onUpdate = { [weak self] in
            guard let self = self else { return }
            self.applySnapshot(viewModels: self.viewModel.sectionViewModels)
        }
        
        viewModel.onShowError = { [weak self] (error) in
            self?.showAlert("Error", message: error.localizedDescription)
        }
    }
}
