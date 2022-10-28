//
//  CoreDataServiceHolder.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 28.10.2022.
//

import Foundation

protocol CoreDataServiceHolder {
    var coreDataService: CoreDataServiceContext { get }
}
