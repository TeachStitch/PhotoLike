//
//  ListSection.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 27.10.2022.
//

import UIKit
import Combine

class ListSection {
    // MARK: - Properties
    var items: [AnyHashable] = []
    
    var sectionID: AnyHashable { ObjectIdentifier(self) }
    
    // MARK: - Initialization
    init(items: [AnyHashable] = []) {
        self.items = items
    }
    
    // MARK: - Method(s)
    func refresh() {
        items.removeAll()
    }
    
    func createLayoutSection() -> NSCollectionLayoutSection {
        assertionFailure("You should override this method providing a layout specific for your section")
        return .init(group: .init(layoutSize: .init(widthDimension: .absolute(.zero), heightDimension: .absolute(.zero))))
    }
    
    func supplementaryView(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? { nil }
    
    func configuredCell(collectionView: UICollectionView, indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell? { nil }
}

// MARK: - Hashable
extension ListSection: Hashable {
    static func == (lhs: ListSection, rhs: ListSection) -> Bool {
        return lhs.sectionID == rhs.sectionID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(sectionID)
    }
}
