//
//  ImageCollectionViewCell.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 28.10.2022.
//

import UIKit
import Combine

class ImageCollectionViewCell: UICollectionViewCell, ModelConfigurable {
    
    private enum Constants {
        static let cornerRadius = 10.0
    }
    
    // MARK: Properties
    @Published var model: URL?
    private lazy var imageLoader = ImageLoader()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Element(s)
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Constants.cornerRadius
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = ColorName.gray01.color
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
        setUpAutoLayoutConstraints()
        bind(model: $model)
        
        imageLoader.$image
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.imageView.image = image
            }
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpSubviews()
        setUpAutoLayoutConstraints()
        bind(model: $model)
        
        imageLoader.$image
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.imageView.image = image
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Method(s)
    override func prepareForReuse() {
        imageView.image = nil
        imageLoader.cancel()
        super.prepareForReuse()
    }
    
    private func setUpSubviews() {
        contentView.addSubview(imageView)
    }
    
    private func setUpAutoLayoutConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // MARK: - Binding
    private func bind(model: Published<URL?>.Publisher) {
        model.sink { [weak self] url in
            guard let url = url else { return }
            self?.imageLoader.loadImage(url: url)
        }
        .store(in: &cancellables)
    }
}
