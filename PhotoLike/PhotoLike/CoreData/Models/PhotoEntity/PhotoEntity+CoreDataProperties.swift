//
//  PhotoEntity+CoreDataProperties.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 28.10.2022.
//
//

import Foundation
import CoreData

extension PhotoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoEntity> {
        return NSFetchRequest<PhotoEntity>(entityName: "PhotoEntity")
    }

    @NSManaged public var creationDate: Date?
    @NSManaged public var likesCount: Int64
    @NSManaged public var modificationDate: Date?
    @NSManaged public var remoteUrl: URL?
    @NSManaged public var id: String?
    @NSManaged public var user: UserEntity?

}

extension PhotoEntity: Identifiable {

}
