//
//  UserInfoView.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 28.10.2022.
//

import UIKit

class UserInfoView: UIView {
    private enum Constants {
        static let userInfoStackViewSpacing = 16.0
        static let avatarImageViewSIze = CGSize(width: 32, height: 32)
    }
    
    // MARK: - Properties
    var username: String? {
        get { usernameLabel.text }
        set { usernameLabel.text = newValue }
    }
    
    var avatarImage: UIImage? {
        get { imageView.image }
        set { imageView.image = newValue }
    }
    
    // MARK: UI Element(s)
    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame.size = Constants.avatarImageViewSIze
        imageView.layer.cornerRadius = Constants.avatarImageViewSIze.height / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private(set) lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var userInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            usernameLabel
        ])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = Constants.userInfoStackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
        setUpAutoLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpSubviews()
        setUpAutoLayoutConstraints()
    }
    
    // MARK: - Method(s)
    private func setUpSubviews() {
        addSubview(userInfoStackView)
    }
    
    private func setUpAutoLayoutConstraints() {
        NSLayoutConstraint.activate([
            userInfoStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            userInfoStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            userInfoStackView.topAnchor.constraint(equalTo: topAnchor),
            userInfoStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }
}
