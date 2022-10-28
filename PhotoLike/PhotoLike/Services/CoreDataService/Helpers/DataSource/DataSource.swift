//
//  DataSource.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 28.10.2022.
//

import UIKit
import Combine

class DataSource<Entity: Hashable & Identifiable, SectionID: Hashable> {
    
    @Published var snapshot: NSDiffableDataSourceSnapshot<SectionID, Entity.ID> = .init()
    var cancellables = Set<AnyCancellable>()
    
    func refresh() {
        
    }
    
    func entity(at indexPath: IndexPath) -> Entity? {
        return nil
    }
}
