//
//  TabBarCoordinator.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import UIKit

class TabBarCoordinator: Coordinator, CoordinatorFacade {
    
    private let serviceLocator: ServiceLocator
    private let rootViewController: UINavigationController
    
    init(serviceLocator: ServiceLocator, rootViewController: UINavigationController) {
        self.serviceLocator = serviceLocator
        self.rootViewController = rootViewController
    }
    
    func start() {
        let adapter = TabBarAdapter(serviceLocator: serviceLocator)
        let viewModel = TabBarViewModel(tabBarAdapter: adapter)
        
        let tabBarViewController = TabBarViewController(viewModel: viewModel)
        tabBarViewController.coordinator = self
        viewModel.delegate = tabBarViewController
        
        rootViewController.present(tabBarViewController, animated: true)
    }
}
