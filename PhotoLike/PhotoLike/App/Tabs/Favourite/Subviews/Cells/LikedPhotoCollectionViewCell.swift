//
//  LikedPhotoCollectionViewCell.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 28.10.2022.
//

import UIKit
import Combine

class LikedPhotoCollectionViewCell: UICollectionViewCell, ModelConfigurable {
    
    private enum Constants {
        static let imageViewHeight = 300.0
        static let likeImageViewSize = CGSize(width: 20, height: 20)
        static let cornerRadius = 10.0
        
        enum Layout {
            static let userInfoViewInsets = UIEdgeInsets(top: 8, left: .zero, bottom: .zero, right: 4)
        }
    }
    
    // MARK: - Properties
    @Published var model: PhotoEntity?
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
    
    private lazy var userInfoView: UserInfoView = {
        let view = UserInfoView()
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var likeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        imageView.tintColor = .red
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
    private func setUpSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(userInfoView)
        contentView.addSubview(likeImageView)
    }
    
    private func setUpAutoLayoutConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageViewHeight),
            
            userInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.userInfoViewInsets.left),
            userInfoView.trailingAnchor.constraint(lessThanOrEqualTo: likeImageView.leadingAnchor, constant: -Constants.Layout.userInfoViewInsets.right),
            userInfoView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.Layout.userInfoViewInsets.top),
            userInfoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.Layout.userInfoViewInsets.bottom),
            
            likeImageView.heightAnchor.constraint(equalToConstant: Constants.likeImageViewSize.height),
            likeImageView.widthAnchor.constraint(equalToConstant: Constants.likeImageViewSize.width),
            likeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            likeImageView.centerYAnchor.constraint(equalTo: userInfoView.centerYAnchor)
        ])
    }
    
    // MARK: - Binding
    private func bind(model: Published<PhotoEntity?>.Publisher) {
        model
            .dropFirst()
            .sink { [weak self] model in
                guard let model = model else { return }
                guard let imageUrl = model.remoteUrl, let avatarUrl = model.user?.smallRemoteUrl else { return }
                self?.imageLoader.loadImage(url: imageUrl)
                self?.userInfoView.username = model.user?.username
                self?.userInfoView.imageView.load(url: avatarUrl)
            }
            .store(in: &cancellables)
    }
}
