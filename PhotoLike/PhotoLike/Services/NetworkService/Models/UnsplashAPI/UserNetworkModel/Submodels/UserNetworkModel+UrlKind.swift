//
//  UserNetworkModel+UrlKind.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import Foundation

extension UserNetworkModel {
    struct UrlKind: Decodable {
        let small: URL?
        let medium: URL?
        let large: URL?
    }
}
