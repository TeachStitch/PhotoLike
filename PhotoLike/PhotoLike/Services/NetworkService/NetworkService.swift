//
//  NetworkService.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import Foundation
import Combine

protocol NetworkServiceContext: NetworServicePhotoFeedContext, NetworkServicePhotoSearchContext { }

class NetworkService: NetworkServiceContext {
    
    private lazy var decoder = JSONDecoder()
        
    func publisher<Model: Decodable>(route: Route) -> AnyPublisher<Model, NetworkServiceError> {
        guard let request = route.request else {
            return Fail(error: NetworkServiceError.invalidRequest).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .retry(1)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkServiceError.undefined
                }
                
                switch StatusCodeValidation.handleStatusCode(httpResponse.statusCode) {
                case .success:
                    return data
                case .failure(reason: let reason):
                    throw NetworkServiceError.general(reason)
                case .internalServerError:
                    throw NetworkServiceError.internalServerError
                case .unknown:
                    throw NetworkServiceError.undefined
                }
            }
            .decode(type: Model.self, decoder: decoder)
            .mapError { error in
                switch error {
                case let decodingError as DecodingError:
                    return NetworkServiceError.failedDecodingResponse(decodingError.localizedDescription)
                case let networkServiceError as NetworkServiceError:
                    return networkServiceError
                default:
                    return NetworkServiceError.general(error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
}
