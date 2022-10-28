//
//  PhotoModel.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 27.10.2022.
//

import Foundation

struct PhotoModel: Identifiable {
    let id: String
    let creationDate: Date
    let modificationDate: Date
    let user: UserModel
    let likesCount: Int
    let regularUrl: URL
}

// MARK: - Validation
extension PhotoModel {
    init?(model: PhotoNetworkModel, dateFormatter: ISO8601DateFormatter) {
        guard
            let regularUrl = model.urlKind.regular,
            let user = UserModel(model: model.user),
            let creationDate = dateFormatter.date(from: model.creationDateString),
            let modificationDate = dateFormatter.date(from: model.modificationDateString)
        else { return nil }
        
        self.id = model.id
        self.creationDate = creationDate
        self.modificationDate = modificationDate
        self.likesCount = model.likesCount
        self.user = user
        self.regularUrl = regularUrl
    }
}

extension PhotoModel {
    init?(entity: PhotoEntity) {
        guard
            let id = entity.id,
            let creationDate = entity.creationDate,
            let modificationDate = entity.modificationDate,
            let userEntity = entity.user,
            let user = UserModel(entity: userEntity),
            let regularUrl = entity.remoteUrl
        else { return nil }
        
        self.id = id
        self.creationDate = creationDate
        self.modificationDate = modificationDate
        self.likesCount = Int(entity.likesCount)
        self.user = user
        self.regularUrl = regularUrl
    }
}

// MARK: - Hashable
extension PhotoModel: Hashable {
    static func == (lhs: PhotoModel, rhs: PhotoModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
