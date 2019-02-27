//
//  SignInViewController.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

final class SignInViewController: UIViewController {

    private var viewModel: SignInControllerViewModelType!

    convenience init(viewModel: SignInControllerViewModelType) {
        self.init()
        self.viewModel = viewModel
    }
    // MARK: - Properties
    // MARK: Callbacks

    var didTouchCreateAccount: EmptyClosure?
    var didTouchSignIn: EmptyClosure?
    var doneCallback: (() -> Void)?

    // MARK: Views

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
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
    }

    override func configureViewModel() {
        super.configureViewModel()
    }



    private func setupNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = ViewConfig.Colors.background
    }
}
