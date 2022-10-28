//
//  Array+Extensions.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import Foundation

extension Array where Element == URLQueryItem {
    init(_ dictionary: [String: LosslessStringConvertible]) {
        self = dictionary.map { URLQueryItem(name: $0, value: $1.description) }
    }
}
