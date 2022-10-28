//
//  UserNetworkModel.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import Foundation

struct UserNetworkModel: Decodable {
    let id: String
    let username: String
    let name: String
    let imageUrlKind: UrlKind
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case name
        case imageUrlKind = "profile_image"
    }
}
