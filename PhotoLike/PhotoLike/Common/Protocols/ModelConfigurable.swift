//
//  ModelConfigurable.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import Foundation

protocol ModelConfigurable: AnyObject {
    associatedtype Model
    
    var model: Model? { get set }
    func set(model: Model)
}

extension ModelConfigurable {
    func set(model: Model) {
        self.model = model
    }
}
