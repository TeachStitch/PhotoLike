//
//  ServiceLocator+Holders.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import Foundation

extension ServiceLocator {
    
    private enum Constant {
            static let errorMessage = "'%@' cannot be resolved"
    }
    
    var networkService: NetworkServiceContext {
        guard let networkService: NetworkService = self.resolve() else {
            fatalError(.init(format: Constant.errorMessage,
                             arguments: [String(describing: NetworkService.self)]))

        }
        return networkService
    }
    
    var coreDataService: CoreDataServiceContext {
        guard let coreDataService: CoreDataService = self.resolve() else {
            fatalError(.init(format: Constant.errorMessage,
                             arguments: [String(describing: CoreDataService.self)]))

        }
        return coreDataService
    }
}

// MARK: - Holders conformance
extension ServiceLocator: NetworkServiceHolder { }
extension ServiceLocator: CoreDataServiceHolder { }
