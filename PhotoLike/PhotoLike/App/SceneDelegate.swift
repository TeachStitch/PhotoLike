//
//  SceneDelegate.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private(set) var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let serviceLocator = ServiceLocator()
        
        // Register services
        registerNetworkService(in: serviceLocator)
        registerCoreDataService(in: serviceLocator)
        
        let appCoordinator = AppCoordinator(window: window, serviceLocator: serviceLocator)
        appCoordinator.start()
        
        self.appCoordinator = appCoordinator
    }
}

// MARK: - Service(s) registration
extension SceneDelegate {
    private func registerNetworkService(in serviceLocator: ServiceLocator) {
        serviceLocator.register(NetworkService())
    }
    
    private func registerCoreDataService(in serviceLocator: ServiceLocator) {
        serviceLocator.register(CoreDataService(name: .standard))
    }
}
