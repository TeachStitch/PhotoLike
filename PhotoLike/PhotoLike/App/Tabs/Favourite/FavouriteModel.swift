//
//  FavouriteModel.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import Foundation
import Combine

protocol FavouriteModelProvider {
    func fetchLikedPhotos() -> AnyPublisher<[PhotoEntity], Error>
}

class FavouriteModel: FavouriteModelProvider {
    typealias Context = CoreDataServiceHolder
    
    // MARK: - Properties
    private let coreDataService: CoreDataServiceContext
    
    // MARK: - Initialization
    init(serviceLocator: Context) {
        self.coreDataService = serviceLocator.coreDataService
    }
    
    func fetchLikedPhotos() -> AnyPublisher<[PhotoEntity], Error> {
        coreDataService.fetchPhotos()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
