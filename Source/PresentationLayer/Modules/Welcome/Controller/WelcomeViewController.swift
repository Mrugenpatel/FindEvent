//
//  WelcomeViewController.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit
import SnapKit

final class WelcomeViewController: UIViewController {

    // MARK: - Properties

    private var viewModel: WelcomeViewModelType!

    convenience init(viewModel: WelcomeViewModelType) {
        self.init()
        self.viewModel = viewModel
    }

    // MARK: Callbacks

    var doneCallback: EmptyClosure?

    // MARK: Views

    private lazy var signInButton = setupSignInButton()
    private lazy var signUpButton = setupSignUpButton()
    private lazy var buttonsStackView = setupStackView()

    // MARK: Configuration

    override func configureView() {
        super.configureView()
        containerView.backgroundColor = ViewConfig.Colors.background
        attachButtonsStackView()
    }

    override func configureViewModel() {
        super.configureViewModel()
        viewModel.didTouchSignIn = { [unowned self] in
            self.showingSignInVC()
        }
        viewModel.didTouchSignUp = { [unowned self] in
            self.showingSignUpVC()
        }
    }

    // MARK: Life Cycle

    override func loadView() {
        super.loadView()
        configureView()
        configureViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    // MARK: Setup

    private func setupStackView() -> UIStackView {
        let buttonsStackView = UIStackView()
        buttonsStackView.axis = .vertical
        buttonsStackView.alignment = .fill //leading - trailling edges
        buttonsStackView.distribution = .fill
        buttonsStackView.spacing = 10
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

    private func setupSignInButton() -> Button {
        let signInButton = Button()
        signInButton.setTitle(viewModel.signInButtonTitle, for: .normal)
        signInButton.titleLabel?.font = Font.bold(of: 18)
        signInButton.setTitleColor(ViewConfig.Colors.textWhite, for: .normal)
        signInButton.backgroundColor = ViewConfig.Colors.blue
        signInButton.didTouchUpInside = { [unowned self] in
            self.viewModel.didTouchSignIn?()
        }

        return signInButton
    }

    private func setupSignUpButton() -> Button {
        let signUpButton = Button()
        signUpButton.setTitle(viewModel.signUpButtonTitle, for: .normal)
        signUpButton.titleLabel?.font = Font.bold(of: 18)
        signUpButton.setTitleColor(ViewConfig.Colors.textWhite, for: .normal)
        signUpButton.backgroundColor = ViewConfig.Colors.blue
        signUpButton.didTouchUpInside = { [unowned self] in
            self.viewModel.didTouchSignUp?()
        }

        return signUpButton
    }

    // MARK: Attachments

    private func attachButtonsStackView() {
        containerView.addSubview(buttonsStackView)
        buttonsStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(15)
        }
    }

    // MARK: Navigation

    private func showingSignUpVC() {
        let signUpViewController = SignUpViewController(
            viewModel: SignUpControllerViewModel(
                emailAuthService: EmailAuthService(
                    userService: UserService(),
                    imageService: ImageService()),
                facebookAuthService: FacebookAuthService(),
                userInputValidator: UserInputValidator()))
        signUpViewController.doneCallback = doneCallback
        navigationController?.pushViewController(signUpViewController, animated: true)
    }

    private func showingSignInVC() {
        let signInViewController = SignInViewController(
            viewModel: SignInControllerViewModel(
                emailAuthService: EmailAuthService(userService: UserService(),
                                                   imageService: ImageService()),
                facebookAuthService: FacebookAuthService(),
                userInputValidator: UserInputValidator()))
                signInViewController.doneCallback = doneCallback
                navigationController?.pushViewController(signInViewController, animated: true)
    }
}

