//
//  PlainObjectsDataSource.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 28.10.2022.
//

import Foundation

class PlainObjectDataSource<Entity: Hashable & Identifiable, SectionID: Hashable>: DataSource<Entity, SectionID> {
    
    struct Section: Hashable {
        let id: SectionID
        let items: [Entity]
    }
    
    private var sections: [Section] = []
    private let pagination: Pagination<Section>
    
    init(pagination: Pagination<Section>) {
        self.pagination = pagination
    }
    
    override func refresh() {
        snapshot.deleteAllItems()
        
        pagination.loadIfNeeded(mode: .normal, offset: .zero, limit: 30)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                guard case .failure(let error) = completion else { return }
                assertionFailure("Load error: \(error)")
            } receiveValue: { [weak self] sections in
                guard let self = self else { return }
                sections.forEach { section in
                    self.snapshot.appendSections([section.id])
                    self.snapshot .appendItems(section.items.map(\.id), toSection: section.id)
                }
            }
            .store(in: &cancellables)
    }
    
    override func entity(at indexPath: IndexPath) -> Entity? {
        return sections[indexPath.section].items[indexPath.item]
    }
}
