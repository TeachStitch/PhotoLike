//
//  NetworkServiceHolder.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 27.10.2022.
//

import Foundation

protocol NetworkServiceHolder {
    var networkService: NetworkServiceContext { get }
}
