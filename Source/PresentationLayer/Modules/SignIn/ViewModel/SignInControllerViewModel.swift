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
    var forgotBtnTitle: String { get }
    var emailPlaceholderTitle: String { get }
    var passwordPlaceholderTitle: String { get }
    var didTouchSignInViaFacebook: EmptyClosure? { get set }
    var didTouchSignInViaEmail: EmptyClosure? { get set }
    var didTouchForgotPassword: EmptyClosure? { get set }
    var emailData: String? { get set }
    var passwordData: String? { get set }
    var didCatchSigningInError: ((String) -> (Void))? { get set }
    var didSignedIn: EmptyClosure? { get set }
    var willStartSigningIn: EmptyClosure? { get set }
    func signInViaEmail()
    func signInViaFacebook()
    func forgotPassword()
}

final class SignInControllerViewModel: SignInControllerViewModelType {
    private struct Strings {
        static let emailBtnTitle = NSLocalizedString("Sign In", comment: "")
        static let forgotBtnTitle = NSLocalizedString("Forgot Password?", comment: "")
        static let facebookBtnTitle = NSLocalizedString("Sign In via Facebook", comment: "")
        static let emailPlaceholderTitle = NSLocalizedString("Email", comment: "")
        static let passwordPlaceholderTitle = NSLocalizedString("Password", comment: "")
    }

    // MARK: Properties

    private let emailAuthService: EmailAuthService
    private let facebookAuthService: FacebookAuthService
    private let userInputValidator: UserInputValidator

    var emailBtnTitle = Strings.emailBtnTitle
    var facebookBtnTitle = Strings.facebookBtnTitle
    var forgotBtnTitle = Strings.forgotBtnTitle
    var emailPlaceholderTitle = Strings.emailPlaceholderTitle
    var passwordPlaceholderTitle = Strings.passwordPlaceholderTitle

    var emailData: String?
    var passwordData: String?

    // MARK: Callbacks

    var didTouchSignInViaFacebook: EmptyClosure?
    var didTouchSignInViaEmail: EmptyClosure?
    var didTouchForgotPassword: EmptyClosure?
    var didCatchSigningInError: ((String) -> (Void))?
    var didSignedIn: EmptyClosure?
    var willStartSigningIn: EmptyClosure?

    init(emailAuthService: EmailAuthService,
         facebookAuthService: FacebookAuthService,
         userInputValidator: UserInputValidator) {
        self.emailAuthService = emailAuthService
        self.facebookAuthService = facebookAuthService
        self.userInputValidator = userInputValidator
    }

    func signInViaEmail() {
        willStartSigningIn?()
        do {
            let signinParams = try userInputValidator.validateSignIn(
                email: emailData,
                password: passwordData)

            emailAuthService.signIn(
                withEmail: signinParams.email,
                withPassword: signinParams.password)
            { [unowned self] responseResult in
                switch responseResult {
                case .success(_):
                    self.didSignedIn?()
                case .failure(let error):
                    self.didCatchSigningInError?(error.localizedDescription)
                }
            }
        } catch let error {
            didCatchSigningInError?(error.localizedDescription)
        }
    }

    func signInViaFacebook() {
        //
    }

    func forgotPassword() {
        do {
            let forgotPasswordParams = try userInputValidator.validateForgotPassword(
                email: emailData)

            emailAuthService.forgotPassword(
                withEmail: forgotPasswordParams)
            { [unowned self] responseResult in
                switch responseResult {
                case .success(_):
                    self.didCatchSigningInError?("Reset email has been sent to your login email, please follow the instructions in the mail to reset your password")
                case .failure(let error):
                    self.didCatchSigningInError?(error.localizedDescription)
                }
            }
        } catch let error {
            didCatchSigningInError?(error.localizedDescription)
        }
    }
}
