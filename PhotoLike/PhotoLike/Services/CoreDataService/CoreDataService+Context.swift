//
//  CoreDataService+Context.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 28.10.2022.
//

import Foundation
import Combine

protocol CoreDataServiceContext {
    func fetchPhotos() -> AnyPublisher<[PhotoEntity], Error>
    func deletePhoto(_ photo: PhotoModel) -> AnyPublisher<PhotoModel, Error>
    func create(photo: PhotoModel) -> AnyPublisher<PhotoModel, Error>
}

extension CoreDataService: CoreDataServiceContext {
    func fetchPhotos() -> AnyPublisher<[PhotoEntity], Error> {
        Future { [weak self] promise in
            guard let self = self else { return }
            
            Task {
                do {
                    promise(.success(try await self.fetch(on: self.mainContext)))
                } catch let error {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func create(photo: PhotoModel) -> AnyPublisher<PhotoModel, Error> {
        Future { [weak self] promise in
            guard let self = self else { return }
            
            Task {
                do {
                    let entities: [PhotoEntity] = try await self.fetch(on: self.backgroundContext,
                                                                       predicate: NSPredicate(format: "SELF.id == %@", photo.id))
                    
                    guard entities.isEmpty else {
                        promise(.failure(NSError(domain: "Dublicate", code: 2)))
                        return
                    }
                    
                    try await self.backgroundContext.perform { [weak self] in
                        guard let self = self else { return }
                        
                        PhotoEntity(photo: photo, insertInto: self.backgroundContext)
                        promise(.success(photo))
                    }
                    
                    try await self.saveContextIfNeeded(self.backgroundContext)
                } catch let error {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func deletePhoto(_ photo: PhotoModel) -> AnyPublisher<PhotoModel, Error> {
        Future { [weak self] promise in
            guard let self = self else { return }
            
            Task {
                do {
                    let entities: [PhotoEntity] = try await self.fetch(on: self.backgroundContext,
                                                                       predicate: NSPredicate(format: "SELF.id == %@", photo.id))
                    guard let entity = entities.first else {
                        promise(.failure(NSError(domain: "Entity doesn't exist", code: 1)))
                        return
                    }
                    
                    try await self.delete(url: entity.objectID.uriRepresentation(), on: self.backgroundContext)
                    try await self.saveContextIfNeeded(self.backgroundContext)
                    promise(.success(photo))
                } catch let error {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
