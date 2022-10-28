//
//  ImageLoader.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 28.10.2022.
//

import Combine
import UIKit

class ImageLoader {
    
    @Published private(set) var image: UIImage?
    private let cache: URLCache
    private var subscription: AnyCancellable?
    
    init(cache: URLCache = .shared) {
        self.cache = cache
    }
    
    func loadImage(url: URL) {
        if let data = cache.cachedResponse(for: URLRequest(url: url))?.data, let image = UIImage(data: data) {
            self.image = image
            return
        }
        
        subscription = URLSession.shared
            .dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global())
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
    
    func cancel() {
        subscription?.cancel()
    }
}
