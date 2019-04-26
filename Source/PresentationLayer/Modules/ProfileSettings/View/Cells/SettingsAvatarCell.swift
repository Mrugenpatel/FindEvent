//
//  SettingsAvatarCell.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 4/20/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation

class SettingsAvatarCell: TableViewCell {

    private lazy var selectAvatarView = configuredSelectAvatarView()

    private func configuredSelectAvatarView() -> SelectAvatarView {
        let selectAvatarView = SelectAvatarView()

        return selectAvatarView
    }

    override func configure() {
        //
    }

    private func attachSelectAvatarView() {
        contentView.addSubview(selectAvatarView)
        selectAvatarView.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
    }
}
