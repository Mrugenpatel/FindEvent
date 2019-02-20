//
//  WelcomeControllerViewModel.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation

protocol WelcomeViewModelType {
    var signInButtonTitle: String { get }
    var signUpButtonTitle: String { get }
    var didTouchSignUp: EmptyClosure? { get set }
    var didTouchSignIn: EmptyClosure? { get set }
}

final class WelcomeControllerViewModel: WelcomeViewModelType {
    private struct Strings {
        static let signInButtonTitle = NSLocalizedString("Sign In", comment: "")
        static let signUpButtonTitle = NSLocalizedString("Sign Up", comment: "")
    }

    // MARK: - Properties

    let signInButtonTitle = Strings.signInButtonTitle
    let signUpButtonTitle = Strings.signUpButtonTitle

    // MARK: - Callbacks

    var didTouchSignUp: EmptyClosure?
    var didTouchSignIn: EmptyClosure?
}
