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
    var didTouchSignUpViaFB: EmptyClosure? { get set }
    var didTouchSignUpViaEmail: EmptyClosure? { get set }
    var userImageData: UIImage? { get set }
    var userLocationData: (latitude: String, longtitude: String) { get set }
    var alertMessage: ((String) -> (Void))? { get set }
    func signUpViaEmail()
}

class SignUpControllerViewModel: SignUpControllerViewModelType {

    private struct Strings {
        static let selectUserAvatarViewTitle = NSLocalizedString("Add", comment: "")
    }

    // MARK: Properties

    var selectUserAvatarViewTitle = Strings.selectUserAvatarViewTitle

    private let emailAuthService: EmailAuthService

    private let facebookAuthService: FacebookAuthService

    // MARK: Callbacks

    var alertMessage: ((String) -> (Void))?

    var userImageData: UIImage?

    var userLocationData: (latitude: String, longtitude: String) = ("", "")

    var didTouchSignUpViaFB: EmptyClosure?

    var didTouchSignUpViaEmail: EmptyClosure?

    init(emailAuthService: EmailAuthService, facebookAuthService: FacebookAuthService) {
        self.emailAuthService = emailAuthService
        self.facebookAuthService = facebookAuthService
    }

    // MARK: Actions

    func signUpViaEmail() {
        guard let userImageData = userImageData else { alertMessage?("Choose Image Please"); return}
        emailAuthService.signUp(
            withName: "Yurii Tsymbala",
            withEmail: "lelele1100.71.168.87le@gmail.com",
            withPassword: "lelelle",
            withUserImg: userImageData,
            withLatitude: userLocationData.latitude,
            withLongtitude: userLocationData.longtitude) { responseResult in
                switch responseResult {
                case .success(_):
                    print("Success")
                case .failure(let error):
                    print(error)
                }
        }
    }
}

