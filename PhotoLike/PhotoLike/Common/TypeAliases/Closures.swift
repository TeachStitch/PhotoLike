//
//  Closures.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import Foundation

typealias EmptyClosure = () -> Void

typealias GenericClosure<T> = (T) -> Void

typealias ResultClosure<Success, Failure> = GenericClosure<Result<Success, Failure>> where Failure: Error
