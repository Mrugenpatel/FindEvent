//
//  WelcomeControllerView.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit
import SnapKit

final class WelcomeControllerView: ControllerView {

    private struct Strings {
        static let signInButtonTitle = NSLocalizedString("Sign In", comment: "")
        static let signUpButtonTitle = NSLocalizedString("Sign Up", comment: "")
    }

    let signInButtonTitle = Strings.signInButtonTitle
    let signUpButtonTitle = Strings.signUpButtonTitle

    // MARK: - Properties
    // MARK: Callbacks

    var doneCallback: EmptyClosure?

    var didTouchSignUp: EmptyClosure?
    var didTouchSignIn: EmptyClosure?


    // MARK: Views

    private lazy var buttonsStackView = configuredStackView()
    private lazy var signInButton = configuredSignInButton()
    private lazy var signUpButton = configuredSignUpButton()

    // MARK: - UI
    // MARK: Configuration

    override func configure() {
        super.configure()
        backgroundColor = ViewConfig.Colors.background

        attachButtonsStackView()
    }

    private func configuredStackView() -> UIStackView {
        let buttonsStackView = UIStackView()
        buttonsStackView.axis = .vertical
        buttonsStackView.alignment = .fill //leading - trailling edges
        buttonsStackView.distribution = .fill
        buttonsStackView.spacing = 7

        buttonsStackView.addArrangedSubview(signInButton)
        buttonsStackView.addArrangedSubview(signUpButton)

        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        return buttonsStackView
    }

    private func configuredSignInButton() -> Button {
        let signInButton = Button()
        signInButton.setTitle(signInButtonTitle, for: .normal)
        signInButton.titleLabel?.font = R.font.openSans(size: 12)
        signInButton.setTitleColor(ViewConfig.Colors.textWhite, for: .normal)
        signInButton.backgroundColor = ViewConfig.Colors.blue
        signInButton.didTouchUpInside = { [unowned self] in
            self.didTouchSignIn?()
        }

        return signInButton
    }

    private func configuredSignUpButton() -> Button {
        let signUpButton = Button()
        signUpButton.setTitle(signUpButtonTitle, for: .normal)
        signUpButton.titleLabel?.font = R.font.openSans(size: 12)
        signUpButton.setTitleColor(ViewConfig.Colors.textWhite, for: .normal)
        signUpButton.backgroundColor = ViewConfig.Colors.blue
        signUpButton.didTouchUpInside = { [unowned self] in
            self.didTouchSignUp?()
        }

        return signUpButton
    }

    // MARK: Attachments

    private func attachButtonsStackView() {
        containerView.addSubview(buttonsStackView)
        buttonsStackView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview().inset(15)
        }
    }

}
