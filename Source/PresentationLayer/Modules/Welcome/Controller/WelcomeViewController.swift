//
//  WelcomeViewController.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

final class WelcomeViewController: Controller<
    WelcomeControllerView,
    WelcomeControllerViewModel
> {

    // MARK: - Properties
    // MARK: Callbacks

    var doneCallback: (() -> Void)?

    // MARK: - UI
    // MARK: Configuration

    override func configureView() {
        super.configureView()

        rootView.didTouchSignUp = { [unowned self] in
            self.navigateToSignUpVC()
        }

        rootView.didTouchSignIn = { [unowned self] in
            self.navigateToSignInVC()
        }
    }

    private func navigateToSignUpVC() {
        let signUpViewController = SignUpViewController(viewModel: SignUpControllerViewModel())
        signUpViewController.doneCallback = doneCallback
        navController?.pushViewController(signUpViewController, animated: true)
    }

    private func navigateToSignInVC() {
        let signInViewController = SignInViewController(viewModel: SignControllerViewModel())
        signInViewController.doneCallback = doneCallback
        navController?.pushViewController(signInViewController, animated: true)
    }
}
