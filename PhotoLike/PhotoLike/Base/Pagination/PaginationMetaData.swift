//
//  PaginationMetaData.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 27.10.2022.
//

import Foundation

struct PaginationMetadata {
    var page: Int
    var limit: Int
    var total: Int
    
    var totalPages: Int { total / limit }
}
