//
//  HomeModel.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import Foundation
import Combine

protocol HomeModelProvider {
    func fetchPhotos(page: Int, perPage: Int, total: Int) -> AnyPublisher<([PhotoModel], PaginationMetadata), NetworkServiceError>
    func searchPhotos(query: String, page: Int, perPage: Int) -> AnyPublisher<([PhotoModel], PaginationMetadata), NetworkServiceError>
}

class HomeModel: HomeModelProvider {
    typealias Context = NetworkServiceHolder
    
    // MARK: - Properties
    private let networkService: NetworServicePhotoFeedContext & NetworkServicePhotoSearchContext
    private lazy var dateFormatter = ISO8601DateFormatter()
    
    // MARK: - Initialization
    init(serviceLocator: Context) {
        self.networkService = serviceLocator.networkService
    }
    
    // MARK: - Method(s)
    func fetchPhotos(page: Int, perPage: Int, total: Int) -> AnyPublisher<([PhotoModel], PaginationMetadata), NetworkServiceError> {
        networkService.fetchPhotos(page: page, perPage: perPage, order: .latest)
            .subscribe(on: DispatchQueue.global())
            .map { [dateFormatter] model in model.compactMap { PhotoModel(model: $0, dateFormatter: dateFormatter) } }
            .map { ($0, PaginationMetadata(page: page, limit: perPage, total: total)) }
            .eraseToAnyPublisher()
    }
    
    func searchPhotos(query: String, page: Int, perPage: Int) -> AnyPublisher<([PhotoModel], PaginationMetadata), NetworkServiceError> {
        networkService.searchPhotos(query: query, page: page, perPage: perPage, filter: .low)
            .subscribe(on: DispatchQueue.global())
            .map { [dateFormatter] model in
                (model.photos.compactMap { PhotoModel(model: $0, dateFormatter: dateFormatter) }, model.total)
            }
            .map { photos, total in (photos, PaginationMetadata(page: page, limit: perPage, total: total)) }
            .eraseToAnyPublisher()
    }
}
