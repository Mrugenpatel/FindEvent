//
//  ProfileSettingsViewController.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 3/30/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

final class ProfileSettingsViewController: UIViewController {

    private var viewModel: ProfileSettingsControllerViewModel!

    convenience init(viewModel: ProfileSettingsControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configuredNavigationBar()
    }

    // MARK: Callbacks

    var doneCallback: EmptyClosure?

    // MARK: Views

   // private var tableView = configuredTableView()

    // MARK: Configuration

    override func configureView() {
        super.configureView()
        containerView.backgroundColor = ViewConfig.Colors.background

    }

    // add tableView with custom cells with footers with additional info

    override func configureViewModel() {
        super.configureViewModel()

    }


    private func configuredNavigationBar() {
        navigationItem.title = "Edit Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: #selector(save))
    }


    // MARK: Actions

    @objc func save() {

    }
    

}
