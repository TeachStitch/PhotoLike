//
//  CoreDataServiceError.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 28.10.2022.
//

import Foundation

enum CoreDataServiceError: Error {
    case save(Error)
    case fetch(Error)
    case delete(Error)
    case general(String)
}
