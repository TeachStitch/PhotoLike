//
//  PhotoFeedPagination.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 28.10.2022.
//

import Foundation
import Combine

class PhotoFeedPagination: Pagination<PhotoModel> {
    
    private let model: HomeModelProvider
    
    init(model: HomeModelProvider) {
        self.model = model
        super.init()
    }
    
    override func fetch(mode: PaginationMode, limit: Int) -> AnyPublisher<([PhotoModel], PaginationMetadata), Error> {
        switch mode {
        case .search(let query):
            return model.searchPhotos(query: query, page: page, perPage: limit)
                .mapError { $0 as Error }
                .eraseToAnyPublisher()
        case .normal:
            return model.fetchPhotos(page: page, perPage: limit, total: 250)
                .mapError { $0 as Error }
                .eraseToAnyPublisher()
        }
    }
}
