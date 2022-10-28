//
//  LikedPhotoSection.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 28.10.2022.
//

import UIKit

class LikedPhotoSection: ListSection {
    // MARK: - Method(s)
    override func createLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(350))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(350))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(5)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10

        return section
    }

    override func configuredCell(collectionView: UICollectionView, indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell? {
        let cell: LikedPhotoCollectionViewCell? = collectionView.dequeueReusableCell(for: indexPath)
        
        if let item = item as? PhotoEntity {
            cell?.set(model: item)
        }

        return cell
    }
}
