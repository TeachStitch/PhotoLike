//
//  HomeViewModel.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import Foundation
import Combine

protocol HomeViewModelProvider {
    func transform(_ input: AnyPublisher<HomeViewModelInput, Never>) -> AnyPublisher<HomeViewModelOutput, Never>
}

enum HomeViewModelInput {
    case refreshPhotos
    case onLoad
    case searchTextDidChange(String)
    case prefetchIfNeeded(index: Int)
    case didSeletPhoto(PhotoModel)
}

enum HomeViewModelOutput {
    case setLoading(_ isLoading: Bool)
    case setSections(_ sections: [ListSection])
    case showAlert(_ title: String, _ message: String)
}

class HomeViewModel: HomeViewModelProvider {
    
    typealias PathAction = PassthroughSubject<HomeCoordinator.Path, Never>
    
    // MARK: - Properties
    private let model: HomeModelProvider
    private let pathAction: PathAction
    private let pagination: Pagination<PhotoModel>
    private let photoSection: ListSection
    private let output = PassthroughSubject<HomeViewModelOutput, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var page = 1
    private var paginationMode: PaginationMode = .normal
    
    // MARK: - Initialization
    init(model: HomeModelProvider, pagination: Pagination<PhotoModel>, pathAction: PathAction) {
        self.model = model
        self.pathAction = pathAction
        self.pagination = pagination
        self.photoSection = PhotoSection()
        
        pagination.$isLoading.sink { [weak self] in self?.output.send(.setLoading($0)) }
        .store(in: &cancellables)
    }
    
    func transform(_ input: AnyPublisher<HomeViewModelInput, Never>) -> AnyPublisher<HomeViewModelOutput, Never> {
        input
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            .sink { [weak self] event in
                switch event {
                case .onLoad:
                    self?.fetchPhotos()
                case .searchTextDidChange(let query):
                    self?.paginationMode = query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .normal : .search(query)
                    self?.output.send(.setSections([]))
                    self?.photoSection.refresh()
                    self?.fetchPhotos()
                case .refreshPhotos:
                    self?.output.send(.setSections([]))
                    self?.photoSection.refresh()
                    self?.fetchPhotos()
                case .prefetchIfNeeded(let index):
                    self?.prefetchIfNeeded(from: index)
                case .didSeletPhoto(let photo):
                    self?.pathAction.send(.showPhotoDetails(photo))
                }
            }
            .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func fetchPhotos() {
        pagination.reset()
        prefetchIfNeeded(from: .zero)
    }
    
    private func prefetchIfNeeded(from index: Int) {
        pagination.loadIfNeeded(mode: paginationMode, offset: index, limit: 30)
            .subscribe(on: DispatchQueue.global())
            .sink { [weak self] completion in
                guard case .failure(let error) = completion else { return }
                self?.output.send(.showAlert("Error", error.localizedDescription))
            } receiveValue: { [weak self] photos in
                guard let self = self else { return }
                self.photoSection.items.append(contentsOf: photos)
                self.output.send(.setSections([self.photoSection]))
            }
            .store(in: &cancellables)
    }
}
