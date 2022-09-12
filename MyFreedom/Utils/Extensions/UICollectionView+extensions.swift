//
//  UICollectionView+extensions.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 17.03.2022.
//

import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseId)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseId, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseId)")
        }
        return cell
    }
    
    func register<T: UICollectionReusableView>(_: T.Type, forSupplementaryViewOfKind: String) {
        register(
            T.self,
            forSupplementaryViewOfKind: forSupplementaryViewOfKind,
            withReuseIdentifier: T.reuseId
        )
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind: String, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableSupplementaryView(
            ofKind: ofKind,
            withReuseIdentifier: T.reuseId,
            for: indexPath
        ) as? T else {
            fatalError("Could not dequeue supplementary view with identifier: \(T.reuseId)")
        }
        return cell
    }
}
