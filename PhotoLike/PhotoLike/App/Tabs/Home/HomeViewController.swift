//
//  HomeViewController.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import UIKit
import Combine

class HomeViewController: BaseSearchViewController {
    
    private enum Constants {
        enum Laout {
            static let collectionViewInsets = UIEdgeInsets(top: 12, left: 16, bottom: .zero, right: 16)
        }
    }
    
    // MARK: - Properties
    private let viewModel: HomeViewModelProvider
    private let input = PassthroughSubject<HomeViewModelInput, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var diffableDataSource: UICollectionViewDiffableDataSource<ListSection, AnyHashable> = {
        let dataSource = UICollectionViewDiffableDataSource<ListSection, AnyHashable>(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            return self?
                .diffableDataSource
                .snapshot()
                .sectionIdentifiers[indexPath.section]
                .configuredCell(collectionView: collectionView, indexPath: indexPath, item: item)
        }

        dataSource.supplementaryViewProvider = { [weak self] collectionView, elementKind, indexPath in
            return self?
                .diffableDataSource
                .snapshot()
                .sectionIdentifiers[indexPath.section]
                .supplementaryView(collectionView: collectionView, kind: elementKind, indexPath: indexPath)
        }

        return dataSource
    }()

    private lazy var layout: UICollectionViewCompositionalLayout = {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            return self?.diffableDataSource.snapshot().sectionIdentifiers[sectionIndex].createLayoutSection()
        }
    }()
    
    // MARK: - UI Element(s)
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(ImageCollectionViewCell.self)
        collectionView.refreshControl = refreshControl
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(searchWorkItem, action: #selector(controlAction(_:)), for: .valueChanged)
        
        return control
    }()
    
    // MARK: - Initialization
    init(viewModel: HomeViewModelProvider) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method(s)
    override func loadView() {
        super.loadView()
        setUpSubviews()
        setUpAutoLayoutConstraints()
        bind(viewModel: viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        input.send(.onLoad)
    }
    
    private func setUpSubviews() {
        view.addSubview(collectionView)
    }
    
    private func setUpAutoLayoutConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Laout.collectionViewInsets.left),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Laout.collectionViewInsets.right),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.Laout.collectionViewInsets.top),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.Laout.collectionViewInsets.bottom)
        ])
    }
    
    // MARK: Binding
    private func bind(viewModel: HomeViewModelProvider) {
        let output = viewModel.transform(input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case let .showAlert(title, message):
                    self?.showAlert(title: title, message: message)
                case .setSections(let sections):
                    self?.applySnapshot(sections: sections)
                case .setLoading(let isLoading):
                    if isLoading {
                        self?.refreshControl.beginRefreshing()
                    } else {
                        self?.refreshControl.endRefreshing()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func applySnapshot(sections: [ListSection]) {
        var snapshot = NSDiffableDataSourceSnapshot<ListSection, AnyHashable>()
        
        sections.forEach { section in
            snapshot = self.mergedSnapshot(of: section.items, into: section)
        }
        
        diffableDataSource.apply(snapshot)
    }
    
    // MARK: - Action(s)
    @objc private func controlAction(_ sender: UIRefreshControl) {
        input.send(.refreshPhotos)
    }
}

// MARK: - UISearchBarDelegate
extension HomeViewController {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchWorkItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            self?.input.send(.searchTextDidChange(searchText))
        }
        
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: workItem)
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        input.send(.prefetchIfNeeded(index: indexPath.item))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let photo = diffableDataSource.itemIdentifier(for: indexPath) as? PhotoModel else { return }
        input.send(.didSeletPhoto(photo))
    }
}

extension HomeViewController {
    private func mergedSnapshot(of items: [AnyHashable], into section: ListSection) -> NSDiffableDataSourceSnapshot<ListSection, AnyHashable> {
        var snapshot = diffableDataSource.snapshot()
        
        if snapshot.sectionIdentifiers.contains(section) {
            let existingItems = Set(snapshot.itemIdentifiers(inSection: section))
            let newItems = Set(items)
            let difference = newItems.subtracting(existingItems)
                                    
            snapshot.appendItems(Array(difference), toSection: section)
        
        } else {
            var existingSections = snapshot.sectionIdentifiers
            
            existingSections.append(section)
            existingSections.sort { left, right in
                return (snapshot.sectionIdentifiers.firstIndex(of: left) ?? .zero) < (snapshot.sectionIdentifiers.firstIndex(of: right) ?? .zero)
            }
            
            let indexOfNewSection = existingSections.firstIndex(of: section) ?? .zero
            
            if snapshot.sectionIdentifiers.isEmpty {
                snapshot.appendSections([section])
                
            } else if indexOfNewSection == .zero {
                snapshot.insertSections([section], beforeSection: existingSections[indexOfNewSection + 1])
            
            } else {
                snapshot.insertSections([section], afterSection: existingSections[indexOfNewSection - 1])
            }
            
            snapshot.appendItems(items, toSection: section)
        }
        
        return snapshot
    }
}
