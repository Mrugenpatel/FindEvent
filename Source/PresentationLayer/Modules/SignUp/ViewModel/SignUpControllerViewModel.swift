//
//  SignUpControllerViewModel.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseFirestore

protocol SignUpControllerViewModelType {
    var selectUserAvatarViewTitle: String { get }
    var emailBtnTitle: String { get }
    var facebookBtnTitle: String { get }
    var namePlaceholderTitle: String { get }
    var emailPlaceholderTitle: String { get }
    var passwordPlaceholderTitle: String { get }
    var willStartSigningUp: EmptyClosure? { get set}
    var didTouchSignUpViaFacebook: EmptyClosure? { get set }
    var didTouchSignUpViaEmail: EmptyClosure? { get set }
    var imageData: UIImage? { get set }
    var nameData: String? { get set }
    var emailData: String? { get set }
    var passwordData: String? { get set }
    var locationData: GeoPoint? { get set }
    var didCatchSigningUpError: ((String) -> (Void))? { get set }
    var didSignedUp: EmptyClosure? { get set }
    func signUpViaEmail()
    func signUpViaFacebook()
}

final class SignUpControllerViewModel: SignUpControllerViewModelType {

    private struct Strings {
        static let selectUserAvatarViewTitle = NSLocalizedString("ADD", comment: "")
        static let emailBtnTitle = NSLocalizedString("Sign Up", comment: "")
        static let facebookBtnTitle = NSLocalizedString("Sign Up via Facebook", comment: "")
        static let namePlaceholderTitle = NSLocalizedString("Name", comment: "")
        static let emailPlaceholderTitle = NSLocalizedString("Email", comment: "")
        static let passwordPlaceholderTitle = NSLocalizedString("Password", comment: "")
    }

    // MARK: Properties

    private let emailAuthService: EmailAuthService
    private let facebookAuthService: FacebookAuthService
    private let userInputValidator: UserInputValidator
    private let userDefaultsService: UserDefaultsService
    private let viewController: UIViewController

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
    var locationData: GeoPoint? {
        didSet {
            locationData == nil ? shareCurrentLocation(isSharing: false) : shareCurrentLocation(isSharing: true)
        }
    }

    // MARK: Callbacks

    var didCatchSigningUpError: ((String) -> (Void))?
    var didSignedUp: EmptyClosure?
    var willStartSigningUp: EmptyClosure?
    var didTouchSignUpViaFacebook: EmptyClosure?
    var didTouchSignUpViaEmail: EmptyClosure?

    init(emailAuthService: EmailAuthService,
         facebookAuthService: FacebookAuthService,
         userInputValidator: UserInputValidator,
         userDefaultsService: UserDefaultsService,
         viewController: UIViewController) {
        self.emailAuthService = emailAuthService
        self.facebookAuthService = facebookAuthService
        self.userInputValidator = userInputValidator
        self.userDefaultsService = userDefaultsService
        self.viewController = viewController
    }

    // MARK: Actions

    func signUpViaEmail() {
        willStartSigningUp?()
        do {
            let signupParams = try userInputValidator.validateSignUp(
                name: nameData,
                email: emailData,
                password: passwordData)

            emailAuthService.signUp(
                withName: signupParams.name,
                withEmail: signupParams.email,
                withPassword: signupParams.password,
                withUserImg: imageData,
                withCoordinate: locationData
            ) { [unowned self] responseResult in
                switch responseResult {
                case .success(_):
                    self.didSignedUp?()
                case .failure(let error):
                    self.didCatchSigningUpError?(error.localizedDescription)
                }
            }
        } catch let error {
            didCatchSigningUpError?(error.localizedDescription)
        }
    }

    func signUpViaFacebook() {
        facebookAuthService.signUp(
            viewController: viewController,
            withUserImg: imageData,
            withCoordinate: locationData
        ) { [unowned self] responseResult in
            switch responseResult {
            case .success(_):
                self.didSignedUp?()
            case .failure(let error):
                self.didCatchSigningUpError?(error.localizedDescription)
            }
        }
    }

    func shareCurrentLocation(isSharing: Bool) {
        userDefaultsService.shareCurrentLocation = isSharing
    }
}

