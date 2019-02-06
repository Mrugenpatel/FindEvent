//
//  UICollectionViewReusable.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/6/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

extension UICollectionView {

    // MARK: - Appearance

    func registerCell(
        ofType type: (Reusable & UICollectionViewCell).Type
        ) {
        self.register(type.self, forCellWithReuseIdentifier: type.reuseIdentifier)
    }

    func registerHeaderView(
        ofType type: (Reusable & UICollectionReusableView).Type
        ) {
        self.register(type.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: type.reuseIdentifier)
    }

    func dequeueCell<Cell: Reusable & UICollectionViewCell>(
        ofType type: Cell.Type = Cell.self,
        at indexPath: IndexPath
        ) -> Cell {
        return self.dequeueReusableCell(withReuseIdentifier: type.reuseIdentifier, for: indexPath) as! Cell
    }

    func dequeueHeaderView<HeaderView: Reusable & UICollectionReusableView>(
        ofType type: HeaderView.Type = HeaderView.self,
        at indexPath: IndexPath
        ) -> HeaderView {
        return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: type.reuseIdentifier, for: indexPath) as! HeaderView
    }
}

