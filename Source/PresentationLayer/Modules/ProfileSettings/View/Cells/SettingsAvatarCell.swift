//
//  SettingsAvatarCell.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 4/20/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class SettingsAvatarCell: TableViewCell {

    // MARK: - Views

    lazy var selectAvatarView = configuredSelectAvatarView()

    // MARK: - Configuration

    private func configuredSelectAvatarView() -> SelectAvatarView {
        let selectAvatarView = SelectAvatarView()

        return selectAvatarView
    }

    override func configure() {
        super.configure()
        contentView.backgroundColor = ViewConfig.Colors.background
        attachSelectAvatarView()
    }

    func configure(avatarImage: UIImage?) {
        if avatarImage != nil {
            selectAvatarView.image = avatarImage
        } else {
            selectAvatarView.title = "ADD"
        }
    }

    // MARK: - Attachments

    private func attachSelectAvatarView() {
        contentView.addSubview(selectAvatarView)
        selectAvatarView.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.width.height.equalTo(120)
        }
    }
}
