//
//  TabBarAdapter.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import UIKit

protocol TabBarAdapterContext {
    var adapters: [TabBarAdapterProvider] { get }
}

protocol TabBarAdapterProvider {
    var rootViewController: UINavigationController { get }
}

class TabBarAdapter: TabBarAdapterContext {
    
    private enum Tab: CaseIterable {
        case home
        case favourite
        
        var title: String {
            switch self {
            case .home:
                return "Home"
            case .favourite:
                return "Favourite"
            }
        }
        
        var iconName: String {
            switch self {
            case .home:
                return "house"
            case .favourite:
                return "heart"
            }
        }
    }
    
    private let serviceLocator: ServiceLocator
    private(set) lazy var adapters = getAdapters()
    
    init(serviceLocator: ServiceLocator) {
        self.serviceLocator = serviceLocator
    }
    
    private func getAdapters() -> [TabBarAdapterProvider] {
        Tab.allCases.map { tab in
            switch tab {
            case .home:
                return configureHomeAdapter()
            case .favourite:
                return configureFavouriteAdapter()
            }
        }
    }
    
    private func configureHomeAdapter() -> TabBarAdapterProvider {
        let coordinator = HomeCoordinator(serviceLocator: serviceLocator)
        coordinator.rootViewController.tabBarItem = getTabBarItem(for: .home)
        coordinator.start()
        
        return coordinator
    }
    
    private func configureFavouriteAdapter() -> TabBarAdapterProvider {
        let coordinator = FavouriteCoordinator(serviceLocator: serviceLocator)
        coordinator.rootViewController.tabBarItem = getTabBarItem(for: .favourite)
        coordinator.start()
        
        return coordinator
    }
    
    private func getTabBarItem(for tab: Tab) -> UITabBarItem {
        UITabBarItem(title: tab.title, image: UIImage(systemName: tab.iconName), selectedImage: UIImage(systemName: tab.iconName))
    }
}
