//
//  FavouriteViewController.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import UIKit
import Combine

class FavouriteViewController: BaseViewController {
    
    private enum Constants {
        enum Laout {
            static let collectionViewInsets = UIEdgeInsets(top: 12, left: 16, bottom: .zero, right: 16)
        }
    }
    
    // MARK: - Properties
    private let viewModel: FavouriteViewModelProvider
    private let input = PassthroughSubject<FavouriteViewModelInput, Never>()
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
        collectionView.register(LikedPhotoCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    // MARK: - Initialization
    init(viewModel: FavouriteViewModelProvider) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.send(.onWillAppear)
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
    private func bind(viewModel: FavouriteViewModelProvider) {
        let output = viewModel.transform(input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case let .showAlert(title, message):
                    self?.showAlert(title: title, message: message)
                case let .setSections(sections, deleting):
                    self?.applySnapshot(sections: sections, deleting: deleting)
                }
            }
            .store(in: &cancellables)
    }
    
    private func applySnapshot(sections: [ListSection], deleting flag: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<ListSection, AnyHashable>()
        
        sections.forEach { section in
            snapshot = self.mergedSnapshot(of: section.items, into: section, deleting: flag)
        }
        
        diffableDataSource.apply(snapshot)
    }
}

// MARK: - UICollectionViewDelegate
extension FavouriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let photoEntity = diffableDataSource.itemIdentifier(for: indexPath) as? PhotoEntity else { return }
        input.send(.didSeletPhoto(photoEntity))
    }
}

extension FavouriteViewController {
    private func mergedSnapshot(of items: [AnyHashable], into section: ListSection, deleting flag: Bool) -> NSDiffableDataSourceSnapshot<ListSection, AnyHashable> {
        var snapshot = diffableDataSource.snapshot()
        
        if snapshot.sectionIdentifiers.contains(section) {
            if flag == true {
                snapshot.deleteItems(snapshot.itemIdentifiers(inSection: section))
            }
            
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
