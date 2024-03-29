//
//  SelectAvatarView.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/16/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class SelectAvatarView: View {

    private struct Constants {
        static let borderWidth: CGFloat = 6
        static let borderColor: CGColor = ViewConfig.Colors.grey.cgColor
    }

    // MARK: - Properties

    var title: String {
        get {
            return titleLabel.text ?? ""
        }
        set {
            titleLabel.text = newValue
        }
    }

    var image: UIImage? {
        get {
            return avatarImageView.image
        }
        set {
            avatarImageView.image = newValue
            stackView.isHidden = true
        }
    }

    // MARK: Callbacks

    var didSelectImage: EmptyClosure?

    // MARK: Views

    private lazy var avatarImageView = configuredAvatarImageView()
    private lazy var stackView = configuredStackView()
    private lazy var logoImageView = configuredLogoImageView()
    private lazy var titleLabel = configuredTitleLabel()

    // MARK: - UI
    // MARK: Configuration

    func configure(viewModel: SelectAvatarViewModel) {
        avatarImageView.image = viewModel.image != nil ? viewModel.image : R.image.profilePlaceholder()
        titleLabel.text = viewModel.name
        stackView.isHidden = true
    }

    override func configure() {
        super.configure()
        attachAvatarImageView()
        attachStackView()
        attachLogoImageView()
        attachTitleLabel()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = frame.size.width / 2
    }

    private func configuredAvatarImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = ViewConfig.Colors.blue
        imageView.isOpaque = true
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = Constants.borderWidth
        imageView.layer.borderColor = Constants.borderColor
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectImage)))

        addSubview(imageView)
        imageView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        return imageView
    }

    private func configuredStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0

        return stackView
    }

    private func configuredLogoImageView() -> UIImageView {
        let logoImageView = UIImageView()
        logoImageView.image = R.image.cameraLogo()
        logoImageView.contentMode = .scaleAspectFill

        return logoImageView
    }

    private func configuredTitleLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = ViewConfig.Fonts.bold(of: 20)
        label.textColor = ViewConfig.Colors.textWhite

        return label
    }

    // MARK: - Attachments

    private func attachAvatarImageView() {
        addSubview(avatarImageView)

        avatarImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func attachStackView() {
        avatarImageView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }


    private func attachLogoImageView() {
        stackView.addArrangedSubview(logoImageView)

        logoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
    }

    private func attachTitleLabel() {
        stackView.addArrangedSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(13)
        }
    }

    // MARK: Actions

    @objc
    private func selectImage() {
        didSelectImage?()
    }
}
