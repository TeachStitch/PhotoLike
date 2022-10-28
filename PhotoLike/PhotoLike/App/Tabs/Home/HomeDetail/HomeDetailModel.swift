//
//  HomeDetailModel.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 28.10.2022.
//

import Foundation
import Combine

protocol HomeDetailModelProvider {
    var photo: PhotoModel { get }
    
    func addToFavourites(photo: PhotoModel) -> AnyPublisher<PhotoModel, Error>
    func removeFromFavourites(photo: PhotoModel) -> AnyPublisher<PhotoModel, Error>
}

class HomeDetailModel: HomeDetailModelProvider {
    typealias Context = CoreDataServiceHolder
    
    // MARK: - Properties
    let photo: PhotoModel
    private let coreDataService: CoreDataServiceContext
    
    // MARK: - Initialization
    init(photo: PhotoModel, serviceLocator: Context) {
        self.photo = photo
        self.coreDataService = serviceLocator.coreDataService
    }
    
    // MARK: - Method(s)
    func addToFavourites(photo: PhotoModel) -> AnyPublisher<PhotoModel, Error> {
        coreDataService.create(photo: photo)
    }
    
    func removeFromFavourites(photo: PhotoModel) -> AnyPublisher<PhotoModel, Error> {
        coreDataService.deletePhoto(photo)
    }
}
