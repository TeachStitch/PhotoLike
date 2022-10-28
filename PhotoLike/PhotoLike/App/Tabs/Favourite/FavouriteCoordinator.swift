//
//  FavouriteCoordinator.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import UIKit
import Combine

class FavouriteCoordinator: Coordinator, TabBarAdapterProvider, CoordinatorFacade {
    
    enum Path {
        case showPhotoDetails(PhotoEntity)
    }
    
    // MARK: - Properties
    let rootViewController = UINavigationController()
    private let serviceLocator: ServiceLocator
    private let path = PassthroughSubject<Path, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(serviceLocator: ServiceLocator) {
        self.serviceLocator = serviceLocator
        
        self.path.sink { [weak self] path in
            switch path {
            case .showPhotoDetails(let photoEntity):
                self?.startPhotoDetailsFlow(photoEntity: photoEntity)
            }
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Method(s0
    func start() {
        let model = FavouriteModel(serviceLocator: serviceLocator)
        let viewModel = FavouriteViewModel(model: model, pathAction: path)
        let viewController = FavouriteViewController(viewModel: viewModel)
        
        viewController.coordinator = self
        rootViewController.pushViewController(viewController, animated: false)
    }
    
    private func startPhotoDetailsFlow(photoEntity: PhotoEntity) {
        FavouriteDetailCoordinator(photo: photoEntity, serviceLocator: serviceLocator, rootViewController: rootViewController).start()
    }
}
