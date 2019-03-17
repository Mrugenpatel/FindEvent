//
//  UserInfoHeaderView.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 3/8/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class UserInfoHeaderView: View {

    // MARK: Callbacks

    var didTapView: EmptyClosure?

    // MARK: Views

    private lazy var avatarView = configuredAvatarView()
    private lazy var nameLabel = configuredLabel()
    private lazy var locationLabel = configuredLabel()
    private lazy var disclosureIndicatorView = configuredDisclosureIndicatorView()

    // MARK: - UI
    // MARK: Configuration

    func configure(viewModel: UserInfoHeaderViewModel) {
        avatarView.image = viewModel.image
        locationLabel.text = viewModel.location
        nameLabel.text = viewModel.name
    }

    override func configure() {
        super.configure()
        backgroundColor = ViewConfig.Colors.background
        addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(selectView)))
        isUserInteractionEnabled = true
        attachAvatarView()
        attachNameLabel()
        attachLocationLabel()
        attachDisclosureIndicatorView()
    }

    private func configuredAvatarView() -> SelectAvatarView {
        let imageView = SelectAvatarView()

        return imageView
    }

    private func configuredLabel() -> UILabel {
        let label = UILabel()
        label.font = Font.regular(of: 10)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = ViewConfig.Colors.textWhite

        return label
    }

    private func configuredDisclosureIndicatorView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill

        return imageView
    }

    // MARK: - Attachments

    private func attachAvatarView() {
        addSubview(avatarView)
        avatarView.snp.makeConstraints { maker in
            maker.height.width.equalTo(90)
            maker.top.left.equalToSuperview().inset(15)
        }
    }

    private func attachNameLabel() {
        //addSubview(nameLabel)
    }

    private func attachLocationLabel() {
        //addSubview(locationLabel)
    }

    private func attachDisclosureIndicatorView() {
        //addSubview(disclosureIndicatorView)
    }


    // MARK: Actions

    @objc
    private func selectView() {
        didTapView?()
    }
}
