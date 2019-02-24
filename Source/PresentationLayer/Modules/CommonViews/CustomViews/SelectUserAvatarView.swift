//
//  SelectUserAvatarView.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/16/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class SelectUserAvatarView: View {

    private struct Constants {
        static let borderWidth: CGFloat = 6
        static let borderColor: CGColor = ViewConfig.Colors.grey.cgColor
    }

    // MARK: - Properties
    // MARK: Content

    var title: String! {
        didSet {
            titleLabel.text = title
        }
    }

    var image: UIImage! {  // CHANGE WITH GET AND SET
        didSet {
            avatarImageView.image = image
            stackView.isHidden = true
            userImage?(image)
        }
    }

    var userImage: ((UIImage) -> (Void))? // DELETE

    var didSelectImage: EmptyClosure?

    // MARK: Views

    private lazy var avatarImageView = configuredAvatarImageView()
    private lazy var stackView = configuredStackView()
    private lazy var logoImageView = configuredLogoImageView()
    private lazy var titleLabel = configuredTitleLabel()
    private lazy var tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))


    // MARK: - UI
    // MARK: Configuration


    override func configure() {
        super.configure()
        attachAvatarImageView()
        attachStackView()
        attachLogoImageView()
        attachTitleLabel()
    }

    private func configuredAvatarImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = ViewConfig.Colors.blue
        imageView.isOpaque = true
        imageView.layer.cornerRadius = frame.size.width / 2
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = Constants.borderWidth
        imageView.layer.borderColor = Constants.borderColor
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapRecognizer)

        addSubview(imageView)
        imageView.snp.makeConstraints { maker in
            maker.left.right.top.bottom.equalToSuperview()
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
        label.font = Font.bold(of: 20)
        label.textColor = ViewConfig.Colors.textWhite

        return label
    }

    // MARK: - Attachments

    private func attachAvatarImageView() {
        addSubview(avatarImageView)

        avatarImageView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
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
            make.width.height.equalTo(70)
        }
    }

    private func attachTitleLabel() {
        stackView.addArrangedSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
    }

    // MARK: Actions

    @objc
    private func selectImage() {
        didSelectImage?()
    }
}
