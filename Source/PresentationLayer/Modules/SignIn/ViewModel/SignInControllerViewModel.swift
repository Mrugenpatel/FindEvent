//
//  SignInControllerViewModel.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation

protocol SignInControllerViewModelType {
    var emailBtnTitle: String { get }
    var facebookBtnTitle: String { get }
    var emailPlaceholderTitle: String { get }
    var passwordPlaceholderTitle: String { get }
    var didTouchSignInViaFacebook: EmptyClosure? { get set }
    var didTouchSignInViaEmail: EmptyClosure? { get set }
    var emailData: String? { get set }
    var passwordData: String? { get set }
    var alertMessage: ((String) -> (Void))? { get set }
    var navigate: EmptyClosure? { get set}
    func signInViaEmail()
    func signInViaFacebook()
}

final class SignInControllerViewModel: SignInControllerViewModelType {
    private struct Strings {
        static let emailBtnTitle = NSLocalizedString("Sign In", comment: "")
        static let facebookBtnTitle = NSLocalizedString("Sign In via Facebok", comment: "")
        static let emailPlaceholderTitle = NSLocalizedString("Email", comment: "")
        static let passwordPlaceholderTitle = NSLocalizedString("Password", comment: "")
    }

    // MARK: Properties

    private let emailAuthService: EmailAuthService
    private let facebookAuthService: FacebookAuthService
    private let userInputValidator: UserInputValidator

    var emailBtnTitle = Strings.emailBtnTitle
    var facebookBtnTitle = Strings.facebookBtnTitle
    var emailPlaceholderTitle = Strings.emailPlaceholderTitle
    var passwordPlaceholderTitle = Strings.passwordPlaceholderTitle

    var emailData: String?
    var passwordData: String?

    // MARK: Callbacks

    var didTouchSignInViaFacebook: EmptyClosure?
    var didTouchSignInViaEmail: EmptyClosure?
    var alertMessage: ((String) -> (Void))?
    var navigate: EmptyClosure?

    init(emailAuthService: EmailAuthService,
         facebookAuthService: FacebookAuthService,
         userInputValidator: UserInputValidator) {
        self.emailAuthService = emailAuthService
        self.facebookAuthService = facebookAuthService
        self.userInputValidator = userInputValidator
    }

    func signInViaEmail() {
        do {
            let signinParams = try self.userInputValidator.validateSignIn(
                email: emailData,
                password: passwordData)

//            emailAuthService.signUp(
//                withName: signinParams.name,
//                withEmail: signinParams.email,
//                withPassword: signinParams.password,
//                withUserImg: imageData,
//                withLatitude: locationData.latitude,
//                withLongtitude: locationData.longtitude) { [unowned self] responseResult in
//                    switch responseResult {
//                    case .success(_):
//                        self.navigate?()
//                    case .failure(let error):
//                        self.alertMessage?(error.localizedDescription)
//                    }
//            }

        } catch let error {
            alertMessage?(error.localizedDescription)
        }
    }

    func signInViaFacebook() {
        //
    }
}
