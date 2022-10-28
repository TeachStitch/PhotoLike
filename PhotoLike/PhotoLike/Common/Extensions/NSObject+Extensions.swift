//
//  NSObject+Extensions.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import Foundation

extension NSObject {
    static var identifier: String { "\(String(describing: Self.self))ID" }
}
