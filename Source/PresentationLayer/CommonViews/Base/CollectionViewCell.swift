//
//  CollectionViewCell.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 3/8/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell, Reusable {

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        configure()
    }


    // MARK: - UI
    // MARK: Configuration

    func configure() {

    }
}
