//
//  PhotoEntity+CoreDataClass.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 28.10.2022.
//
//

import Foundation
import CoreData

public class PhotoEntity: NSManagedObject {
    @discardableResult
    convenience init(photo: PhotoModel, insertInto context: NSManagedObjectContext) {
        self.init(entity: PhotoEntity.entity(), insertInto: context)
        self.id = photo.id
        self.likesCount = Int64(photo.likesCount)
        self.remoteUrl = photo.regularUrl
        self.creationDate = photo.creationDate
        self.modificationDate = photo.modificationDate
        self.user = UserEntity(user: photo.user, photo: self, insertInto: context)
    }
}
