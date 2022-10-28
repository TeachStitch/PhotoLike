//
//  FavouriteViewModel.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import Foundation
import Combine

protocol FavouriteViewModelProvider {
    func transform(_ input: AnyPublisher<FavouriteViewModelInput, Never>) -> AnyPublisher<FavouriteViewModelOutput, Never>
}

enum FavouriteViewModelInput {
    case onWillAppear
    case didSeletPhoto(PhotoEntity)
}

enum FavouriteViewModelOutput {
    case setSections(_ sections: [ListSection], _ deleting: Bool)
    case showAlert(_ title: String, _ message: String)
}

class FavouriteViewModel: FavouriteViewModelProvider {
    
    typealias PathAction = PassthroughSubject<FavouriteCoordinator.Path, Never>
    
    // MARK: - Properties
    let title = "Upcoming"
    private let model: FavouriteModelProvider
    private let pathAction: PathAction
    private let likedPhotoSection: ListSection
    private let output = PassthroughSubject<FavouriteViewModelOutput, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(model: FavouriteModelProvider, pathAction: PathAction) {
        self.model = model
        self.pathAction = pathAction
        self.likedPhotoSection = LikedPhotoSection()
    }
    
    func transform(_ input: AnyPublisher<FavouriteViewModelInput, Never>) -> AnyPublisher<FavouriteViewModelOutput, Never> {
        input.sink { [weak self] event in
            switch event {
            case .onWillAppear:
                self?.fetchLikedPhotos()
            case .didSeletPhoto(let photoEntity):
                self?.pathAction.send(.showPhotoDetails(photoEntity))
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func fetchLikedPhotos() {
        model.fetchLikedPhotos()
            .sink { [weak self] completion in
                guard case .failure(let error) = completion else { return }
                self?.output.send(.showAlert("Error", error.localizedDescription))
            } receiveValue: { [weak self] photos in
                guard let self = self else { return }
                self.likedPhotoSection.refresh()
                self.likedPhotoSection.items.append(contentsOf: photos)
                self.output.send(.setSections([self.likedPhotoSection], true))
            }
            .store(in: &cancellables)
    }
}
