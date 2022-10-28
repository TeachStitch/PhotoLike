//
//  Pagination.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 27.10.2022.
//

import Foundation
import Combine

class Pagination<ItemType> {
    
    // MARK: - Properties
    var page = 1
    
    @Published private(set) var isLoading: Bool = false
    
    private var displayedItemsCount: Int = .zero
    private var totalPages: Int?
    private var totalItemsCount: Int?
    
    // MARK: - Method(s)
    func reset() {
        self.totalItemsCount = nil
        self.totalPages = nil
        self.displayedItemsCount = .zero
        self.page = 1
    }
    
    func loadIfNeeded(mode: PaginationMode, offset: Int, limit: Int) -> AnyPublisher<[ItemType], Error> {
        guard shouldPaginate(from: offset) else {
            return Empty().eraseToAnyPublisher()
        }
        
        isLoading = true
        
        return fetch(mode: mode, limit: limit)
            .receive(on: DispatchQueue.main)
            .map { [weak self] items, metadata in
                self?.isLoading = false
                self?.update(metadata: metadata)
                return items
            }
            .eraseToAnyPublisher()
    }
    
    func fetch(mode: PaginationMode, limit: Int) -> AnyPublisher<([ItemType], PaginationMetadata), Error> {
        assertionFailure("You should override following function to providing appropriate items and metadata")
        return Empty().eraseToAnyPublisher()
    }
    
    private func update(metadata: PaginationMetadata) {
        self.displayedItemsCount += metadata.limit
        self.totalItemsCount = metadata.total
        self.totalPages = metadata.totalPages
        self.page = metadata.page + 1
    }
    
    private func shouldPaginate(from offset: Int) -> Bool {
        guard !isLoading else {
            return false
        }
        
        guard let totalItemsCount else { return true }

        let thresholdForFetchingIsReached = (displayedItemsCount - offset) < 10
        let moreContentAvailable = totalItemsCount > displayedItemsCount
        let shouldPaginate = thresholdForFetchingIsReached && moreContentAvailable
                
        return shouldPaginate
    }
}

enum PaginationMode: Equatable {
    case search(String)
    case normal
}
