//
//  TabBarViewModel.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import Foundation

protocol TabBarViewModelProvider {
    func onWillAppear()
}

protocol TabBarViewModelDelegate: AnyObject {
    func registerAdapters(_ adapters: [TabBarAdapterProvider])
}

class TabBarViewModel: TabBarViewModelProvider {
    
    weak var delegate: TabBarViewModelDelegate?
    
    private let tabBarAdapter: TabBarAdapterContext
    
    init(tabBarAdapter: TabBarAdapterContext) {
        self.tabBarAdapter = tabBarAdapter
    }
    
    func onWillAppear() {
        delegate?.registerAdapters(tabBarAdapter.adapters)
    }
}
