//
//  UserInfoHeaderView.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 3/8/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class UserInfoHeaderView: View {

    // MARK: Properties

    var isAnimating: Bool = false {
        didSet {
            isAnimating ? startAnimating() : stopAnimating()
        }
    }

    // MARK: Callbacks

    var didTapView: EmptyClosure?

    // MARK: Views

    private lazy var avatarView = configuredAvatarView()
    private lazy var nameLabel = configuredLabel()
    private lazy var locationLabel = configuredLabel()
    private lazy var disclosureImageView = configuredDisclosureIndicatorView()
    private lazy var activityIndicatorView = configuredActivityIndicatorView()

    // MARK: - UI
    // MARK: Configuration

    func configure(viewModel: UserInfoHeaderViewModel?) {
        avatarView.image = viewModel?.image ?? R.image.profilePlaceholder()
        locationLabel.text = viewModel?.location
        nameLabel.text = viewModel?.name
    }

    override func configure() {
        super.configure()
        backgroundColor = ViewConfig.Colors.background
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectView)))
        attachAvatarView()
        attachNameLabel()
        attachLocationLabel()
        attachDisclosureImageView()
        attachActivityIndicator()
        startAnimating()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func configuredAvatarView() -> SelectAvatarView {
        let imageView = SelectAvatarView()
        imageView.image = R.image.profilePlaceholder()

        return imageView
    }

    private func configuredLabel() -> UILabel {
        let label = UILabel()
        label.font = ViewConfig.Fonts.bold(of: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = ViewConfig.Colors.textWhite

        return label
    }

    private func configuredDisclosureIndicatorView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = R.image.disclosurePlaceholder()

        return imageView
    }

    private func configuredActivityIndicatorView() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(
            style: UIActivityIndicatorView.Style.whiteLarge
        )

        return activityIndicator
    }

    // MARK: - Attachments

    private func attachAvatarView() {
        addSubview(avatarView)

        avatarView.snp.makeConstraints { maker in
            maker.height.width.equalTo(70)
            maker.top.left.equalToSuperview().inset(10)
        }
    }

    private func attachNameLabel() {
        addSubview(nameLabel)

        nameLabel.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.left.equalTo(avatarView.snp.right).offset(15)
        }
    }

    private func attachLocationLabel() {
        //addSubview(locationLabel)
    }

    private func attachDisclosureImageView() {
        addSubview(disclosureImageView)

        disclosureImageView.snp.makeConstraints { maker in
            maker.width.height.equalTo(15)
            maker.centerY.equalToSuperview()
            maker.right.equalToSuperview().inset(15)
        }
    }

    private func attachActivityIndicator() {
        addSubview(activityIndicatorView)

        activityIndicatorView.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
    }

    // MARK: Actions

    @objc
    private func selectView() {
        didTapView?()
    }

    private func startAnimating() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        userIteractionEnabled(isEnabled: false)
    }

    private func stopAnimating() {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.isHidden = true
            self.userIteractionEnabled(isEnabled: true)
        }
    }

    private func userIteractionEnabled(isEnabled: Bool) {
        isUserInteractionEnabled = isEnabled
    }
}
