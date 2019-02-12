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
    var willCreateAccount: EmptyClosure?
    var willSignIn: EmptyClosure?

    // MARK: - UI
    // MARK: Configuration

    override func configureView() {
        super.configureView()

        rootView.didTouchCreateAccount = { [unowned self] in
            self.willCreateAccount?()
        }

        rootView.didTouchSignIn = { [unowned self] in
            self.willSignIn?()
        }

        rootView.didTouchCreateAccount = { [unowned self] in
            self.willCreateAccount?()
        }

        rootView.backgroundColor = UIColor(red: 249, green: 251, blue: 253, alpha: 1)
    }

}
