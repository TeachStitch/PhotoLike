//
//  PhotoNetworkModel.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import Foundation

struct PhotoNetworkModel: Decodable {
    let id: String
    let creationDateString: String
    let modificationDateString: String
    let likesCount: Int
    let user: UserNetworkModel
    let urlKind: UrlKind
    
    enum CodingKeys: String, CodingKey {
        case id
        case creationDateString = "created_at"
        case modificationDateString = "updated_at"
        case likesCount = "likes"
        case user
        case urlKind = "urls"
    }
}
