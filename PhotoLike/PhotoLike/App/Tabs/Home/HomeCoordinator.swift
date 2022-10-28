//
//  HomeCoordinator.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import UIKit
import Combine

class HomeCoordinator: Coordinator, TabBarAdapterProvider, CoordinatorFacade {
    
    enum Path {
        case showPhotoDetails(PhotoModel)
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
            case .showPhotoDetails(let photo):
                self?.startPhotoDetailsFlow(photo: photo)
            }
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Method(s)
    func start() {
        let model = HomeModel(serviceLocator: serviceLocator)
        let pagination = PhotoFeedPagination(model: model)
        let viewModel = HomeViewModel(model: model, pagination: pagination, pathAction: path)
        let viewController = HomeViewController(viewModel: viewModel)
        
        viewController.coordinator = self
        rootViewController.pushViewController(viewController, animated: false)
    }
    
    private func startPhotoDetailsFlow(photo: PhotoModel) {
        HomeDetailCoordinator(photo: photo, serviceLocator: serviceLocator, rootViewController: rootViewController).start()
    }
}
