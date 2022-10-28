//
//  SearchResultsNetworkModel.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 27.10.2022.
//

import Foundation

struct SearchResultsNetworkModel: Decodable {
    let total: Int
    let totalPages: Int
    let photos: [PhotoNetworkModel]
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case photos = "results"
    }
}
