//
//  SignInViewController.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit
import SVProgressHUD

final class SignInViewController: UIViewController {

    // MARK: - Properties

    private var viewModel: SignInControllerViewModelType!

    convenience init(viewModel: SignInControllerViewModelType) {
        self.init()
        self.viewModel = viewModel
    }

    // MARK: - Callbacks

    var doneCallback: (() -> Void)?

    // MARK: - Views

    private lazy var containerStackView = configuredContainerStackView()
    private lazy var emailTextField = configuredEmailTextField()
    private lazy var passwordTextField = configuredPasswordTextField()
    private lazy var signinButtonViaEmail = setupSigninButtonViaEmail()
    private lazy var signinButtonViaFacebook = setupSigninButtonViaFacebook()
    private lazy var forgotPasswordButton = setupForgotPasswordButton()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configuredNavigationBar()
    }

    // MARK: - Configuration

    override func configureView() {
        super.configureView()
        containerView.backgroundColor = ViewConfig.Colors.background
        attachContainerStackView()
        attachEmailTextField()
        attachPasswordTextField()
        attachSigninButtonViaEmail()
        attachSigninButtonViaFacebook()
        attachForgotPasswordButton()
    }

    override func configureViewModel() {
        super.configureViewModel()

        viewModel.willStartSigningIn = { [unowned self] in
            self.enableUserIteraction(isUserInteractionEnabled: false)
            SVProgressHUD.show()
        }

        viewModel.didCatchSigningInError = { [unowned self] message in
            self.enableUserIteraction(isUserInteractionEnabled: true)
            SVProgressHUD.showError(withStatus: message)
        }

        viewModel.didSignedIn = {
            SVProgressHUD.showSuccess(withStatus: nil)
            self.doneCallback?()
        }

        viewModel.didTouchSignInViaEmail = { [unowned self] in
            self.viewModel.signInViaEmail()
        }

        viewModel.didTouchSignInViaFacebook = { [unowned self] in
            self.viewModel.signInViaFacebook()
        }

        viewModel.didTouchForgotPassword = { [unowned self] in
            self.viewModel.forgotPassword()
        }
    }

    private func configuredNavigationBar() {
        navigationController?.isNavigationBarHidden = false
    }

    private func configuredContainerStackView() -> UIStackView {
        let containerStackView = UIStackView()
        containerStackView.axis = .vertical
        containerStackView.alignment = .fill //leading - trailling edges
        containerStackView.distribution = .fill
        containerStackView.spacing = 10

        return containerStackView
    }

    private func configuredEmailTextField() -> TextField {
        let emailTextField = TextField()
        emailTextField.autocorrectionType = .no
        emailTextField.keyboardType = .emailAddress
        emailTextField.placeholder = viewModel.emailPlaceholderTitle
        emailTextField.addTarget(self, action: #selector(observeEmailTextField), for: .editingChanged)

        return emailTextField
    }

    private func configuredPasswordTextField() -> TextField {
        let passwordTextField = TextField()
        passwordTextField.autocorrectionType = .no
        passwordTextField.keyboardType = .default
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = viewModel.passwordPlaceholderTitle
        passwordTextField.addTarget(self, action: #selector(observePasswordTextField), for: .editingChanged)

        return passwordTextField
    }

    private func setupSigninButtonViaEmail() -> Button {
        let signinButtonViaEmail = Button()
        signinButtonViaEmail.setTitle(viewModel.emailBtnTitle, for: .normal)
        signinButtonViaEmail.titleLabel?.font = ViewConfig.Fonts.bold(of: 18)
        signinButtonViaEmail.setTitleColor(ViewConfig.Colors.textWhite, for: .normal)
        signinButtonViaEmail.backgroundColor = ViewConfig.Colors.blue
        signinButtonViaEmail.didTouchUpInside = { [unowned self] in
            self.viewModel.didTouchSignInViaEmail?()
        }

        return signinButtonViaEmail
    }

    private func setupSigninButtonViaFacebook() -> Button {
        let signinButtonViaFacebook = Button()
        signinButtonViaFacebook.setTitle(viewModel.facebookBtnTitle, for: .normal)
        signinButtonViaFacebook.titleLabel?.font = ViewConfig.Fonts.bold(of: 18)
        signinButtonViaFacebook.setTitleColor(ViewConfig.Colors.textWhite, for: .normal)
        signinButtonViaFacebook.backgroundColor = ViewConfig.Colors.blue
        signinButtonViaFacebook.didTouchUpInside = { [unowned self] in
            self.viewModel.didTouchSignInViaFacebook?()
        }

        return signinButtonViaFacebook
    }

    private func setupForgotPasswordButton() -> Button {
        let forgotPasswordButton = Button()
        forgotPasswordButton.setTitle(viewModel.forgotBtnTitle, for: .normal)
        forgotPasswordButton.titleLabel?.font = ViewConfig.Fonts.bold(of: 14)
        forgotPasswordButton.setTitleColor(ViewConfig.Colors.textLightGrey, for: .normal)
        forgotPasswordButton.backgroundColor = .clear
        forgotPasswordButton.didTouchUpInside = { [unowned self] in
            self.viewModel.didTouchForgotPassword?()
        }

        return forgotPasswordButton
    }

    // MARK: - Attachments

    private func attachContainerStackView() {
        containerView.addSubview(containerStackView)

        containerStackView.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.left.right.equalToSuperview().inset(30)
        }
    }

    private func attachEmailTextField() {
        containerStackView.addArrangedSubview(emailTextField)

        emailTextField.snp.makeConstraints { maker in
            maker.height.equalTo(40)
        }
    }

    private func attachPasswordTextField() {
        containerStackView.addArrangedSubview(passwordTextField)

        passwordTextField.snp.makeConstraints { maker in
            maker.height.equalTo(40)
        }
    }

    private func attachSigninButtonViaEmail() {
        containerStackView.addArrangedSubview(signinButtonViaEmail)

        signinButtonViaEmail.snp.makeConstraints { maker in
            maker.height.equalTo(50)
        }
    }

    private func attachSigninButtonViaFacebook() {
        containerStackView.addArrangedSubview(signinButtonViaFacebook)

        signinButtonViaFacebook.snp.makeConstraints { maker in
            maker.height.equalTo(50)
        }
    }

    private func attachForgotPasswordButton() {
        containerStackView.addArrangedSubview(forgotPasswordButton)

        forgotPasswordButton.snp.makeConstraints { maker in
            maker.height.equalTo(20)
        }
    }

    // MARK: - Actions

    @objc
    private func observeEmailTextField() {
        viewModel.emailData = emailTextField.text
    }

    @objc
    private func observePasswordTextField() {
        viewModel.passwordData = passwordTextField.text
    }
}
