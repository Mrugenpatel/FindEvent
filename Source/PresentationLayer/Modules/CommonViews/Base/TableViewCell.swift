//
//  TableViewCell.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 3/8/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell, Reusable {

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

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
