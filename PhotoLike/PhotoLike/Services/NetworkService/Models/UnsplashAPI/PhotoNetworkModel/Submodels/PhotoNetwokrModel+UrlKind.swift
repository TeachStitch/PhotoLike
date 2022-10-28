//
//  PhotoNetwokrModel+UrlKind.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import Foundation

extension PhotoNetworkModel {
    struct UrlKind: Decodable {
        let raw: URL?
        let full: URL?
        let regular: URL?
        let small: URL?
        let thumb: URL?
    }
}
