//
//  UserEntity+CoreDataProperties.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 28.10.2022.
//
//

import Foundation
import CoreData

extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var smallRemoteUrl: URL?
    @NSManaged public var username: String?
    @NSManaged public var id: String?
    @NSManaged public var photo: PhotoEntity?

}

extension UserEntity: Identifiable {

}
