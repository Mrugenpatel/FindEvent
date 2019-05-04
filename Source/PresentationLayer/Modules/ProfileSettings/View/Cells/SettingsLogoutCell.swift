//
//  SettingsLogoutCell.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 4/29/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class SettingsLogoutCell: TableViewCell {

    // MARK: - Callbacks

    var logout: EmptyClosure?

    // MARK: - Views

    lazy var button = configuredButton()

    // MARK: - Configuration

    override func configure() {
        super.configure()
        contentView.backgroundColor = ViewConfig.Colors.background
        selectionStyle = .none
        attachButton()
    }

    private func configuredButton() -> Button {
        let button = Button()
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.8969964385, green: 0.2637340426, blue: 0.2784116566, alpha: 1), for: .normal)
        button.backgroundColor = .clear
        button.didTouchUpInside = { [unowned self] in
            self.logout?()
        }

        return button
    }

    // MARK: - Actions

    // MARK: - Attachments

    private func attachButton() {
        contentView.addSubview(button)

        button.snp.makeConstraints { maker in
            maker.left.right.top.equalToSuperview().inset(5)
            maker.height.equalTo(30)
        }
    }
}
