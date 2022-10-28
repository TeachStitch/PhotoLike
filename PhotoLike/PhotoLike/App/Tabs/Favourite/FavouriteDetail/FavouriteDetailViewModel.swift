//
//  FavouriteDetailViewModel.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 28.10.2022.
//

import Foundation
import Combine

protocol FavouriteDetailViewModelProvider {
    var title: String { get }
    
    func transform(_ input: AnyPublisher<FavouriteDetailViewModelInput, Never>) -> AnyPublisher<FavouriteDetailViewModelOutput, Never>
}

enum FavouriteDetailViewModelInput {
    case didTapLike(_ isLiked: Bool)
    case didTapShare
    case onLoad
}

enum FavouriteDetailViewModelOutput {
    case showAlert(_ title: String, _ message: String)
    case loadPhoto(_ photo: PhotoModel)
    case setLikeInterationAvailable(_ isAvailable: Bool)
    case setLikeSelected(_ isSelected: Bool)
}

class FavouriteDetailViewModel: FavouriteDetailViewModelProvider {
    typealias PathAction = PassthroughSubject<FavouriteDetailCoordinator.Path, Never>
    
    // MARK: - Properties
    let title = "Details"
    private let model: FavouriteDetailModelProvider
    private let pathAction: PathAction
    private let output = PassthroughSubject<FavouriteDetailViewModelOutput, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private var photo: PhotoModel? { model.photo }
    
    // MARK: - Initialization
    init(model: FavouriteDetailModelProvider, pathAction: PathAction) {
        self.model = model
        self.pathAction = pathAction
    }
    
    // MARK: - Method(s)
    func transform(_ input: AnyPublisher<FavouriteDetailViewModelInput, Never>) -> AnyPublisher<FavouriteDetailViewModelOutput, Never> {
        input
            .sink { [weak self] event in
                switch event {
                case .onLoad:
                    guard let photo = self?.photo else {
                        self?.output.send(.showAlert("Error", "Data is corrupted. We can't load photo"))
                        return
                    }
                    
                    self?.output.send(.loadPhoto(photo))
                case .didTapLike(let isLiked):
                    self?.handleLikeUpdate(isLiked)
                case .didTapShare:
                    self?.output.send(.showAlert("Share button isn't implemented", "If you want to like a photo. Tap on heart below"))
                }
            }
            .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func handleLikeUpdate(_ isLiked: Bool) {
        guard let photo else { return }
        output.send(.setLikeInterationAvailable(false))
        
        if isLiked {
            model.addToFavourites(photo: photo)
                .subscribe(on: DispatchQueue.global(qos: .utility))
                .sink { [weak self] completion in
                    self?.output.send(.setLikeInterationAvailable(true))
                    guard case .failure(let error) = completion else { return }
                    self?.output.send(.setLikeSelected(false))
                    self?.output.send(.showAlert("Error", error.localizedDescription))
                } receiveValue: { _ in
                }
                .store(in: &cancellables)
            
        } else {
            model.removeFromFavourites(photo: photo)
                .subscribe(on: DispatchQueue.global(qos: .utility))
                .sink { [weak self] completion in
                    self?.output.send(.setLikeInterationAvailable(true))
                    guard case .failure(let error) = completion else { return }
                    self?.output.send(.setLikeSelected(true))
                    self?.output.send(.showAlert("Error", error.localizedDescription))
                } receiveValue: { _ in
                }
                .store(in: &cancellables)
        }
    }
}
