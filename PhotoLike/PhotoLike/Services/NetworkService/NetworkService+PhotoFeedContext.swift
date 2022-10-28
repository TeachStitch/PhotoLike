//
//  NetworkService+PhotoFeedContext.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import Foundation
import Combine

protocol NetworServicePhotoFeedContext {
    func fetchPhotos(page: Int, perPage: Int, order: PhotoOrder) -> AnyPublisher<[PhotoNetworkModel], NetworkServiceError>
}

extension NetworkService: NetworServicePhotoFeedContext {
    func fetchPhotos(page: Int, perPage: Int = 10, order: PhotoOrder = .latest) -> AnyPublisher<[PhotoNetworkModel], NetworkServiceError> {
        let headers = [
            "Authorization": "Client-ID osr97NW4DPLJA69dUXkYvRVLDw5gh-ckwlAtx8sk00M"
        ]
        
        let queryItems: [String: LosslessStringConvertible] = [
            "page": page,
            "per_page": perPage,
            "order_by": order.rawValue
        ]
        
        let router = Router(host: "api.unsplash.com",
                            path: "/photos",
                            queryItems: queryItems,
                            headers: headers)
        
        return publisher(route: router)
    }
}
