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
        static let borderColor: CGColor = ViewConfig.Colors.textLightGrey.cgColor
    }

    // MARK: - Properties
    // MARK: Content

    var setTitle: String! {
        didSet {
            titleLabel.text = setTitle
        }
    }

    var setImage: UIImage! {
        didSet {
            avatarImageView.image = setImage
            stackView.isHidden = true
        }
    }

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
        label.font = Font.bold(of: 18)
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
            make.width.height.equalTo(60)
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


//// MARK: - Types
//
//typealias DidTapActionControl = () -> Void
//
//
//// MARK: - Properties
//// MARK: Content
//
//var title: String {
//    get {
//        return titleLabel.text ?? ""
//    }
//    set {
//        titleLabel.text = newValue
//    }
//}
//
//var selectedTab: CategoriesControllerTab = .groups {
//    didSet {
//        actionControl.title = selectedTab.actionName
//        tabsView.selectTab(selectedTab)
//    }
//}
//
//// MARK: Callbacks
//
//var didTapActionControl: DidTapActionControl? {
//    didSet {
//        actionControl.didTouchUpInside = didTapActionControl
//    }
//}
//
//// MARK: Views
//
//private lazy var topView = configuredTopView()
//private lazy var bottomView = configuredBottomView()
//
//private lazy var titleLabel = configuredTitleLabel()
//lazy var actionControl = configuredActionControl()
//
//lazy var tabsView = configuredTabsView()
//
//
//// MARK: - UI
//// MARK: Configuration
//
//override func configure() {
//    super.configure()
//
//    backgroundColor = UIColor(red: 249, green: 251, blue: 253)
//
//    attachTopView()
//    attachBottomView()
//    attachTitleLabel()
//    attachActionControl()
//    attachTabsView()
//}
