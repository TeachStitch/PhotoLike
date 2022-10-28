//
//  UserEntity+CoreDataClass.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 28.10.2022.
//
//

import Foundation
import CoreData

public class UserEntity: NSManagedObject {
    @discardableResult
    convenience init(user: UserModel, photo: PhotoEntity, insertInto context: NSManagedObjectContext) {
        self.init(entity: UserEntity.entity(), insertInto: context)
        self.id = user.id
        self.name = user.name
        self.username = user.username
        self.smallRemoteUrl = user.avatarUrl
        self.photo = photo
    }
}
