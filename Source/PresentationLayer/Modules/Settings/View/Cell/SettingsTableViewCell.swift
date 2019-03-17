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

    // MARK: Configuration

    func configure(withViewModel viewModel: SettingsTableCellViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        logoImageView.image = viewModel.image
    }

    override func configure() {
        super.configure()
        backgroundColor = ViewConfig.Colors.background
        accessoryType = .disclosureIndicator
        attachContainerView()
        attachLogoImageView()
        attachTitleLabel()
        attachSubtitleLabel()
    }

    private func configuredContainerView() -> View {
        let view = View()
        view.backgroundColor = ViewConfig.Colors.background

        return view
    }

    private func configuredTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = Font.bold(of: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = ViewConfig.Colors.textWhite

        return label
    }

    private func configuredSubtitleLabel() -> UILabel  {
        let label = UILabel()
        label.font = Font.regular(of: 16)
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

    // MARK: Attachments

    private func attachContainerView() {
        addSubview(containerView)

        containerView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }

    private func attachLogoImageView() {
        containerView.addSubview(logoImageView)

        logoImageView.snp.makeConstraints { maker in
            maker.width.height.equalTo(40)
            maker.top.equalToSuperview().inset(10)
            maker.left.equalToSuperview().inset(15)
        }
    }

    private func attachTitleLabel() {
        containerView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.left.equalTo(logoImageView.snp.right).offset(10)
        }
    }

    private func attachSubtitleLabel() {
        containerView.addSubview(subtitleLabel)

        subtitleLabel.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.right.equalToSuperview().inset(35)
        }
    }
}
