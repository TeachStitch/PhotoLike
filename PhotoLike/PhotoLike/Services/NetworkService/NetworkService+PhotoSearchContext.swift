//
//  NetworkService+PhotoSearchContext.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 27.10.2022.
//

import Foundation
import Combine

protocol NetworkServicePhotoSearchContext {
    func searchPhotos(query: String, page: Int, perPage: Int, filter: ContentFilter) -> AnyPublisher<SearchResultsNetworkModel, NetworkServiceError>
}

extension NetworkService: NetworkServicePhotoSearchContext {
    func searchPhotos(query: String, page: Int, perPage: Int, filter: ContentFilter = .low) -> AnyPublisher<SearchResultsNetworkModel, NetworkServiceError> {
        let headers = [
            "Authorization": "Client-ID osr97NW4DPLJA69dUXkYvRVLDw5gh-ckwlAtx8sk00M"
        ]
        
        let queryItems: [String: LosslessStringConvertible] = [
            "query": query,
            "page": page,
            "per_page": perPage,
            "content_filter": filter.rawValue
        ]
        
        let router = Router(host: "api.unsplash.com",
                            path: "/search/photos",
                            queryItems: queryItems,
                            headers: headers)
        
        return publisher(route: router)
    }
}
