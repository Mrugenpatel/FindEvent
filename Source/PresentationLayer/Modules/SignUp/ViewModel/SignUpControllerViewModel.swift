//
//  SignUpControllerViewModel.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit
import CoreLocation

protocol SignUpControllerViewModelType {
    var selectUserAvatarViewTitle: String { get }
    var emailBtnTitle: String { get }
    var facebookBtnTitle: String { get }
    var namePlaceholderTitle: String { get }
    var emailPlaceholderTitle: String { get }
    var passwordPlaceholderTitle: String { get }
    var didTouchSignUpViaFacebook: EmptyClosure? { get set }
    var didTouchSignUpViaEmail: EmptyClosure? { get set }
    var imageData: UIImage? { get set }
    var nameData: String? { get set }
    var emailData: String? { get set }
    var passwordData: String? { get set }
    var locationData: (
        latitude: String,
        longtitude: String
        ) { get set }
    var alertMessage: ((String) -> (Void))? { get set }
    var navigate: EmptyClosure? { get set}
    func signUpViaEmail()
    func signUpViaFacebook()
}

final class SignUpControllerViewModel: SignUpControllerViewModelType {

    private struct Strings {
        static let selectUserAvatarViewTitle = NSLocalizedString("ADD", comment: "")
        static let emailBtnTitle = NSLocalizedString("Sign Up", comment: "")
        static let facebookBtnTitle = NSLocalizedString("Sign Up via Facebok", comment: "")
        static let namePlaceholderTitle = NSLocalizedString("Name", comment: "")
        static let emailPlaceholderTitle = NSLocalizedString("Email", comment: "")
        static let passwordPlaceholderTitle = NSLocalizedString("Password", comment: "")
    }

    // MARK: Properties

    private let emailAuthService: EmailAuthService
    private let facebookAuthService: FacebookAuthService
    private let userInputValidator: UserInputValidator

    var selectUserAvatarViewTitle = Strings.selectUserAvatarViewTitle
    var emailBtnTitle = Strings.emailBtnTitle
    var facebookBtnTitle = Strings.facebookBtnTitle
    var namePlaceholderTitle = Strings.namePlaceholderTitle
    var emailPlaceholderTitle = Strings.emailPlaceholderTitle
    var passwordPlaceholderTitle = Strings.passwordPlaceholderTitle

    var nameData: String?
    var emailData: String?
    var passwordData: String?
    var imageData: UIImage?
    var locationData: (latitude: String, longtitude: String) = ("", "")

    // MARK: Callbacks

    var alertMessage: ((String) -> (Void))?
    var navigate: EmptyClosure?
    var didTouchSignUpViaFacebook: EmptyClosure?
    var didTouchSignUpViaEmail: EmptyClosure?

    init(emailAuthService: EmailAuthService,
         facebookAuthService: FacebookAuthService,
         userInputValidator: UserInputValidator) {
        self.emailAuthService = emailAuthService
        self.facebookAuthService = facebookAuthService
        self.userInputValidator = userInputValidator
    }

    // MARK: Actions

    func signUpViaEmail() {
        do {
            let signupParams = try self.userInputValidator.validateSignUp(
                name: nameData,
                email: emailData,
                password: passwordData)

            emailAuthService.signUp(
                withName: signupParams.name,
                withEmail: signupParams.email,
                withPassword: signupParams.password,
                withUserImg: imageData,
                withLatitude: locationData.latitude,
                withLongtitude: locationData.longtitude) { [unowned self] responseResult in
                    switch responseResult {
                    case .success(_):
                        self.navigate?()
                    case .failure(let error):
                        self.alertMessage?(error.localizedDescription)
                    }
            }
        } catch let error {
            alertMessage?(error.localizedDescription)
        }
    }

    func signUpViaFacebook() {
        //
    }
}

