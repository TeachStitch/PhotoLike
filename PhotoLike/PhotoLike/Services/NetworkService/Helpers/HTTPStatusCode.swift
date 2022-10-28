//
//  HTTPStatusCode.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import Foundation

enum HTTPStatusCode: Int {
    case success = 200
    case created = 201
    case internalServerError = 500
    case pageLimit = 426
    case unauthourized = 401
    case requestLimit = 429
}
