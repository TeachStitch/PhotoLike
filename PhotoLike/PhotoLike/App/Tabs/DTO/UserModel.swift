//
//  UserModel.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 27.10.2022.
//

import Foundation

struct UserModel: Identifiable {
    let id: String
    let username: String
    let name: String
    let avatarUrl: URL
}

// MARK: - Validation
extension UserModel {
    init?(model: UserNetworkModel) {
        guard let smallUrl = model.imageUrlKind.small else { return nil }
        
        self.id = model.id
        self.name = model.name
        self.username = model.username
        self.avatarUrl = smallUrl
    }
}

extension UserModel {
    init?(entity: UserEntity) {
        guard
            let id = entity.id,
            let name = entity.name,
            let username = entity.username,
            let avatarUrl = entity.smallRemoteUrl
        else { return nil }
        
        self.id = id
        self.name = name
        self.username = username
        self.avatarUrl = avatarUrl
    }
}

// MARK: - Hashable
extension UserModel: Hashable {
    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
