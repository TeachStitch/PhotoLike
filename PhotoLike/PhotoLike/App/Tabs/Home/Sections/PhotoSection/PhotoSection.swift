//
//  PhotoSection.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 27.10.2022.
//

import UIKit

class PhotoSection: ListSection {
    // MARK: - Method(s)
    override func createLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(5)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10

        return section
    }

    override func configuredCell(collectionView: UICollectionView, indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell? {
        let cell: ImageCollectionViewCell? = collectionView.dequeueReusableCell(for: indexPath)
        
        if let item = item as? PhotoModel {
            cell?.set(model: item.regularUrl)
        }

        return cell
    }
}
