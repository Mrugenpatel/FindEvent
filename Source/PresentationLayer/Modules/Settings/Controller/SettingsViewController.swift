//
//  SettingsViewController.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    private var viewModel: SettingsControllerViewModel?

    convenience init(viewModel: SettingsControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    // MARK: Callbacks
    
    var doneCallback: EmptyClosure?

    // MARK: Views

    private lazy var tableView = setupTableView()

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

    // MARK: Setup

    private func setupNavigationBar() {
        //
    }


    private func setupTableView() -> UITableView {
        let tableView = UITableView()


        return tableView

    }
}
