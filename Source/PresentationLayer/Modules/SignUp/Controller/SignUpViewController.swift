//
//  SignUpViewController.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit
import CoreLocation

class SignUpViewController: UIViewController {

    // MARK: Properties

    private var locationManager: CLLocationManager!
    private var viewModel: SignUpControllerViewModelType!

    convenience init(viewModel: SignUpControllerViewModelType) {
        self.init()
        self.viewModel = viewModel
    }

    // MARK: Callbacks

    var doneCallback: EmptyClosure?

    // MARK: Views
    private lazy var containerStackView = setupContainerStackView()
    private lazy var selectUserAvatarView = setupSelectUserAvatarView()
    private lazy var nameTextField = setupNameTextField()
    private lazy var emailTextField = setupEmailTextField()
    private lazy var passwordTextField = setupPasswordTextField()
    private lazy var signupButtonViaEmail = setupSignupButtonViaEmail()
    private lazy var signupButtonViaFacebook = setupSignupButtonViaFacebook()

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        configureView()
        configureViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupNavigationBar()
    }

    // MARK: Configuration

    override func configureView() {
        super.configureView()
        containerView.backgroundColor = ViewConfig.Colors.background
        attachContainerStackView()
        attachSelectUserAvatarView()
        attachNameTextField()
        attachEmailTextField()
        attachPasswordTextField()
        attachSignupButtonViaEmail()
        attachSignupButtonViaFacebook()
    }

    override func configureViewModel() {
        super.configureViewModel()

        selectUserAvatarView.didSelectImage = { [unowned self] in
            ImagePicker { picker in
                picker.didPickImage = { [unowned self] image in
                    self.selectUserAvatarView.image = image
                    self.viewModel.imageData = image
                }
                }.show(from: self)
        }

        viewModel.alertMessage = { [unowned self] message in
           print(message)
        }

        viewModel.didTouchSignUpViaEmail = { [unowned self] in
            self.viewModel.signUpViaEmail()
        }
    }

    // MARK: Setup

    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 200
        locationManager.startUpdatingLocation()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = ViewConfig.Colors.background
    }

    private func setupContainerStackView() -> UIStackView {
        let containerStackView = UIStackView()
        containerStackView.axis = .vertical
        containerStackView.alignment = .center //leading - trailling edges
        containerStackView.distribution = .fill
        containerStackView.spacing = 10

        return containerStackView
    }

    private func setupSelectUserAvatarView() -> SelectUserAvatarView {
        let selectUserAvatarView = SelectUserAvatarView()
        selectUserAvatarView.title = viewModel.selectUserAvatarViewTitle

        return selectUserAvatarView
    }

    private func setupNameTextField() -> TextField {
        let nameTextField = TextField()
        nameTextField.autocorrectionType = .no
        nameTextField.keyboardType = .default
        nameTextField.placeholder = viewModel.namePlaceholderTitle
        nameTextField.addTarget(self, action: #selector(observeNameTextField), for: .editingChanged) // UICONTROL EVENT???

        return nameTextField
    }

    private func setupEmailTextField() -> TextField {
        let emailTextField = TextField()
        emailTextField.autocorrectionType = .no
        emailTextField.keyboardType = .emailAddress
        emailTextField.placeholder = viewModel.emailPlaceholderTitle
        emailTextField.addTarget(self, action: #selector(observeEmailTextField), for: .editingChanged)

        return emailTextField
    }

    private func setupPasswordTextField() -> TextField {
        let passwordTextField = TextField()
        passwordTextField.autocorrectionType = .no
        passwordTextField.keyboardType = .default
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = viewModel.passwordPlaceholderTitle
        passwordTextField.addTarget(self, action: #selector(observePasswordTextField), for: .editingChanged)

        return passwordTextField
    }

    private func setupSignupButtonViaEmail() -> Button {
        let signupButtonViaEmail = Button()
        signupButtonViaEmail.setTitle(viewModel.emailBtnTitle, for: .normal)
        signupButtonViaEmail.titleLabel?.font = Font.bold(of: 18)
        signupButtonViaEmail.setTitleColor(ViewConfig.Colors.textWhite, for: .normal)
        signupButtonViaEmail.backgroundColor = ViewConfig.Colors.blue
        signupButtonViaEmail.didTouchUpInside = { [unowned self] in
            self.viewModel.didTouchSignUpViaEmail?()
        }

        return signupButtonViaEmail
    }

    private func setupSignupButtonViaFacebook() -> Button {
        let signupButtonViaFacebook = Button()
        signupButtonViaFacebook.setTitle(viewModel.facebookBtnTitle, for: .normal)
        signupButtonViaFacebook.titleLabel?.font = Font.bold(of: 18)
        signupButtonViaFacebook.setTitleColor(ViewConfig.Colors.textWhite, for: .normal)
        signupButtonViaFacebook.backgroundColor = ViewConfig.Colors.blue
        signupButtonViaFacebook.didTouchUpInside = { [unowned self] in
            self.viewModel.didTouchSignUpViaFacebook?()
        }

        return signupButtonViaFacebook
    }

    // MARK: Attachments

    private func attachContainerStackView() {
        containerView.addSubview(containerStackView)

        containerStackView.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.left.right.equalToSuperview().inset(30)
        }
    }

    private func attachSelectUserAvatarView() {
        containerStackView.addArrangedSubview(selectUserAvatarView)

        selectUserAvatarView.snp.makeConstraints { maker in
            maker.width.height.equalTo(120)
        }
    }

    private func attachNameTextField() {
        containerStackView.addArrangedSubview(nameTextField)

        nameTextField.snp.makeConstraints { maker in
            maker.height.equalTo(40)
            maker.left.right.equalToSuperview()
        }
    }

    private func attachEmailTextField() {
        containerStackView.addArrangedSubview(emailTextField)

        emailTextField.snp.makeConstraints { maker in
            maker.height.equalTo(40)
            maker.left.right.equalToSuperview()
        }
    }

    private func attachPasswordTextField() {
        containerStackView.addArrangedSubview(passwordTextField)

        passwordTextField.snp.makeConstraints { maker in
            maker.height.equalTo(40)
            maker.left.right.equalToSuperview()
        }
    }

    private func attachSignupButtonViaEmail() {
        containerStackView.addArrangedSubview(signupButtonViaEmail)

        signupButtonViaEmail.snp.makeConstraints { maker in
            maker.height.equalTo(50)
            maker.left.right.equalToSuperview()
        }
    }

    private func attachSignupButtonViaFacebook() {
        containerStackView.addArrangedSubview(signupButtonViaFacebook)

        signupButtonViaFacebook.snp.makeConstraints { maker in
            maker.height.equalTo(50)
            maker.left.right.equalToSuperview()
        }
    }

    // MARK: Actions

    @objc
    private func observeNameTextField() {
        viewModel.nameData = nameTextField.text
    }

    @objc
    private func observeEmailTextField() {
        viewModel.emailData = emailTextField.text
    }

    @objc
    private func observePasswordTextField() {
        viewModel.passwordData = passwordTextField.text
    }
}

extension SignUpViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        viewModel.locationData = (
            String(locations[0].coordinate.latitude),
            String(locations[0].coordinate.longitude)
        )
        locationManager.stopUpdatingLocation()
    }
}
