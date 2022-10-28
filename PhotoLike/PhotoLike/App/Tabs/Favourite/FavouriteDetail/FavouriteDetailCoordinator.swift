//
//  FavouriteDetailCoordinator.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 28.10.2022.
//

import UIKit
import Combine

class FavouriteDetailCoordinator: Coordinator, TabBarAdapterProvider, CoordinatorFacade {
    
    enum Path {
    }
    
    // MARK: - Properties
    let rootViewController: UINavigationController
    private let serviceLocator: ServiceLocator
    private let photo: PhotoEntity
    private let path = PassthroughSubject<Path, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(photo: PhotoEntity, serviceLocator: ServiceLocator, rootViewController: UINavigationController) {
        self.photo = photo
        self.serviceLocator = serviceLocator
        self.rootViewController = rootViewController
        
        self.path.sink { _ in
            
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Method(s0
    func start() {
        let model = FavouriteDetailModel(photoEntity: photo, serviceLocator: serviceLocator)
        let viewModel = FavouriteDetailViewModel(model: model, pathAction: path)
        let viewController = FavouriteDetailViewController(viewModel: viewModel)
        
        viewController.coordinator = self
        rootViewController.pushViewController(viewController, animated: true)
    }
}
