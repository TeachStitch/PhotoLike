//
//  HomeDetailCoordinator.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 28.10.2022.
//

import UIKit
import Combine

class HomeDetailCoordinator: Coordinator, TabBarAdapterProvider, CoordinatorFacade {
    
    enum Path {
    }
    
    // MARK: - Properties
    let rootViewController: UINavigationController
    private let serviceLocator: ServiceLocator
    private let photo: PhotoModel
    private let path = PassthroughSubject<Path, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(photo: PhotoModel, serviceLocator: ServiceLocator, rootViewController: UINavigationController) {
        self.photo = photo
        self.serviceLocator = serviceLocator
        self.rootViewController = rootViewController
        
        self.path.sink { _ in
            
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Method(s0
    func start() {
        let model = HomeDetailModel(photo: photo, serviceLocator: serviceLocator)
        let viewModel = HomeDetailViewModel(model: model, pathAction: path)
        let viewController = HomeDetailViewController(viewModel: viewModel)
        
        viewController.coordinator = self
        rootViewController.pushViewController(viewController, animated: true)
    }
}
