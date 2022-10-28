//
//  FavouriteDetailModel.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 28.10.2022.
//

import Foundation
import Combine

protocol FavouriteDetailModelProvider {
    var photo: PhotoModel? { get }
    
    func addToFavourites(photo: PhotoModel) -> AnyPublisher<PhotoModel, Error>
    func removeFromFavourites(photo: PhotoModel) -> AnyPublisher<PhotoModel, Error>
}

class FavouriteDetailModel: FavouriteDetailModelProvider {
    typealias Context = CoreDataServiceHolder
    
    // MARK: - Properties
    let photo: PhotoModel?
    private let coreDataService: CoreDataServiceContext
    
    // MARK: - Initialization
    init(photoEntity: PhotoEntity, serviceLocator: Context) {
        self.coreDataService = serviceLocator.coreDataService
        self.photo = PhotoModel(entity: photoEntity)
    }
    
    // MARK: - Method(s)
    func addToFavourites(photo: PhotoModel) -> AnyPublisher<PhotoModel, Error> {
        coreDataService.create(photo: photo)
    }
    
    func removeFromFavourites(photo: PhotoModel) -> AnyPublisher<PhotoModel, Error> {
        coreDataService.deletePhoto(photo)
    }
}
