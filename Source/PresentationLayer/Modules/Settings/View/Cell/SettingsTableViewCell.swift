//
//  SettingsTableViewCell.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 3/17/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class SettingsTableViewCell: TableViewCell {

    // MARK: Views

    private lazy var containerView = configuredContainerView()
    private lazy var titleLabel = configuredTitleLabel()
    private lazy var subtitleLabel = configuredSubtitleLabel()
    private lazy var logoImageView = configuredImageView()
    private lazy var disclosureImageView = configuredDislosureImageView()

    // MARK: Configuration

    func configure(withViewModel viewModel: SettingsTableCellViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        logoImageView.image = viewModel.image
    }

    override func configure() {
        super.configure()
        backgroundColor = ViewConfig.Colors.dark
        attachContainerView()
        attachLogoImageView()
        attachTitleLabel()
        attachDisclosureImageView()
        attachSubtitleLabel()
    }

    private func configuredContainerView() -> UIView {
        let view = UIView()
        view.backgroundColor = ViewConfig.Colors.background
        return view
    }

    private func configuredTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = ViewConfig.Fonts.bold(of: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = ViewConfig.Colors.textWhite

        return label
    }

    private func configuredSubtitleLabel() -> UILabel  {
        let label = UILabel()
        label.font = ViewConfig.Fonts.regular(of: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = ViewConfig.Colors.textLightGrey

        return label
    }

    private func configuredImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5.0

        return imageView
    }

    private func configuredDislosureImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = R.image.disclosurePlaceholder()

        return imageView
    }

    // MARK: Attachments

    private func attachContainerView() {
        contentView.addSubview(containerView)

        containerView.snp.makeConstraints { maker in
            maker.left.right.top.equalToSuperview()
            maker.bottom.equalToSuperview().inset(2)
        }
    }

    private func attachLogoImageView() {
        containerView.addSubview(logoImageView)

        logoImageView.snp.makeConstraints { maker in
            maker.width.height.equalTo(36)
            maker.top.equalToSuperview().inset(8)
            maker.left.equalToSuperview().inset(10)
        }
    }

    private func attachTitleLabel() {
        containerView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.left.equalTo(logoImageView.snp.right).offset(10)
        }
    }

    private func attachDisclosureImageView() {
        containerView.addSubview(disclosureImageView)

        disclosureImageView.snp.makeConstraints { maker in
            maker.width.height.equalTo(15)
            maker.centerY.equalToSuperview()
            maker.right.equalToSuperview().inset(15)
        }
    }

    private func attachSubtitleLabel() {
        containerView.addSubview(subtitleLabel)

        subtitleLabel.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.right.equalTo(disclosureImageView.snp.left).offset(-10)
        }
    }
}
