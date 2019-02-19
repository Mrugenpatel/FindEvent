//
//  SignInViewController.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {


    private var viewModel: SignInControllerViewModel?

    convenience init(viewModel: SignInControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    // MARK: - Properties
    // MARK: Callbacks

    var didTouchCreateAccount: EmptyClosure?
    var didTouchSignIn: EmptyClosure?
    var doneCallback: (() -> Void)?

    // MARK: Views


    // MARK: - UI
    // MARK: Configuration
}
