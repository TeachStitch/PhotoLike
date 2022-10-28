//
//  AppCoordinator.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import UIKit

class AppCoordinator: Coordinator {
    
    let window: UIWindow
    let serviceLocator: ServiceLocator
    let rootViewController = UINavigationController()
    
    init(window: UIWindow, serviceLocator: ServiceLocator) {
        self.serviceLocator = serviceLocator
        self.window = window
        self.window.makeKeyAndVisible()
        self.window.rootViewController = rootViewController
    }
    
    func start() {
        TabBarCoordinator(serviceLocator: serviceLocator, rootViewController: rootViewController).start()
    }
}
