//
//  HomeDetailViewController.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 28.10.2022.
//

import UIKit
import Combine

class HomeDetailViewController: BaseViewController {
    enum Constants {
        static let bottomStackViewSpacing = 2.0
        static let photoImageViewHeightMultiplier = 0.7
        static let likeButtonSize = CGSize(width: 32, height: 32)
        static let photoImageViewCornerRadius = 10.0
        
        enum Layout {
            static let likeButtonRightIndent = 24.0
            static let bottomStackViewInsets = UIEdgeInsets(top: 16, left: 24, bottom: 24, right: 24)
            static let photoImageViewInsets = UIEdgeInsets(top: 8, left: 24, bottom: 16, right: 24)
            static let avatarViewInsets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        }
    }
    
    // MARK: - Properties
    private let viewModel: HomeDetailViewModelProvider
    private let input = PassthroughSubject<HomeDetailViewModelInput, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        return formatter
    }()
    
    // MARK: - UI Element(s)
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = ColorName.gray01.color
        imageView.layer.cornerRadius = Constants.photoImageViewCornerRadius
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var userInfoView: UserInfoView = {
        let view = UserInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.backgroundColor = ColorName.gray01.color
        button.frame.size = Constants.likeButtonSize
        button.tintColor = .black
        button.layer.cornerRadius = Constants.likeButtonSize.height / 2
        button.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var likesCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            likesCountLabel,
            dateLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = Constants.bottomStackViewSpacing
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    // MARK: - Initialization
    init(viewModel: HomeDetailViewModelProvider) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method(s)
    override func loadView() {
        super.loadView()
        setUpSubviews()
        setUpAutoLayoutConstraints()
        bind(viewModel: viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        input.send(.onLoad)
    }
    
    private func setUpSubviews() {
        setUpBarButtons()
        navigationItem.title = viewModel.title
        view.addSubview(photoImageView)
        view.addSubview(userInfoView)
        view.addSubview(likeButton)
        view.addSubview(bottomStackView)
    }
    
    private func setUpAutoLayoutConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.heightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: Constants.photoImageViewHeightMultiplier),
            photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Layout.photoImageViewInsets.left),
            photoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Layout.photoImageViewInsets.right),
            photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.Layout.photoImageViewInsets.top),
            photoImageView.bottomAnchor.constraint(equalTo: userInfoView.topAnchor, constant: -Constants.Layout.photoImageViewInsets.bottom),
            
            userInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Layout.avatarViewInsets.left),
            userInfoView.trailingAnchor.constraint(lessThanOrEqualTo: likeButton.leadingAnchor, constant: -Constants.Layout.avatarViewInsets.right),
            userInfoView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -Constants.Layout.avatarViewInsets.bottom),
            
            likeButton.topAnchor.constraint(equalTo: userInfoView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Layout.likeButtonRightIndent),
            likeButton.heightAnchor.constraint(equalToConstant: Constants.likeButtonSize.height),
            likeButton.widthAnchor.constraint(equalToConstant: Constants.likeButtonSize.width),
                        
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Layout.bottomStackViewInsets.left),
            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Layout.bottomStackViewInsets.right),
            bottomStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.Layout.bottomStackViewInsets.bottom)
        ])
    }
    
    private func setUpBarButtons() {
        navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonTapped(_:))), animated: false)
    }
    
    // MARK: Binding
    private func bind(viewModel: HomeDetailViewModelProvider) {
        let output = viewModel.transform(input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .loadPhoto(let photo):
                    self?.userInfoView.username = photo.user.name
                    self?.photoImageView.load(url: photo.regularUrl)
                    self?.userInfoView.imageView.load(url: photo.user.avatarUrl)
                    self?.likesCountLabel.text = "\(photo.likesCount) likes"
                    self?.dateLabel.text = self?.dateFormatter.string(from: photo.creationDate)
                case let .showAlert(title, message):
                    self?.showAlert(title: title, message: message)
                case .setLikeInterationAvailable(let isAvailable):
                    self?.likeButton.isUserInteractionEnabled = isAvailable
                case .setLikeSelected(let isSelected):
                    self?.likeButton.isSelected = isSelected
                    self?.likeButton.tintColor = isSelected ? .red : .black
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Action(s)
    @objc private func likeButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        sender.tintColor = sender.isSelected ? .red : .black
        input.send(.didTapLike(sender.isSelected))
    }
    
    @objc private func shareButtonTapped(_ sender: UIBarButtonItem) {
        input.send(.didTapShare)
    }
}
