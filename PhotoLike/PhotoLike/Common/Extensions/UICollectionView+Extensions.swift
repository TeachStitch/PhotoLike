//
//  UICollectionView+Extensions.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import UIKit

extension UICollectionView {
    
    enum SupplementaryViewKind {
        case header
        case footer
        case custom(String)
    }
    
    final func register<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.identifier)
    }
    
    final func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T? {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            assertionFailure(
                "Failed to dequeue a cell with identifier \(T.identifier) matching type \(T.self). Check that you registered the cell beforehand."
            )
            return nil
        }
        
        return cell
    }
    
    final func register<T: UICollectionReusableView>(_: T.Type, forSupplementaryViewOfKind: SupplementaryViewKind) {
        switch forSupplementaryViewOfKind {
        case .header:
            register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.identifier)
        case .footer:
            register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.identifier)
        case .custom(let identifier):
            register(T.self, forSupplementaryViewOfKind: identifier, withReuseIdentifier: T.identifier)
        }
    }
    
    final func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: SupplementaryViewKind, for indexPath: IndexPath) -> T? {
        let supplementaryViewKindIdentifier: String
        
        switch kind {
        case .header:
            supplementaryViewKindIdentifier = UICollectionView.elementKindSectionHeader
        case .footer:
            supplementaryViewKindIdentifier = UICollectionView.elementKindSectionFooter
        case .custom(let identifier):
            supplementaryViewKindIdentifier = identifier
        }
        
        guard let supplementaryView = dequeueReusableSupplementaryView(ofKind: supplementaryViewKindIdentifier, withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            assertionFailure(
                "Failed to dequeue a supplementary view with identifier \(T.identifier) matching type \(T.self). "
                + "Check that you registered the supplementary view beforehand."
            )
            return nil
        }
        
        return supplementaryView
    }
}
