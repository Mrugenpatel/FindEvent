//
//  SettingsViewController.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    // MARK: Properties

    private var viewModel: SettingsControllerViewModel?

    convenience init(viewModel: SettingsControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    // MARK: Callbacks
    
    var doneCallback: EmptyClosure?

    // MARK: Views

    private lazy var infoHeaderView = configuredInfoHeaderView()
    private lazy var tableView = configuredTableView()

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

    // MARK: Configuration

    override func configureView() {
        super.configureView()
        containerView.backgroundColor = ViewConfig.Colors.background

    }

    override func configureViewModel() {
        super.configureViewModel()

    }

    // MARK: Setup

    private func configuredNavigationBar() {
        // add edit button
    }

    private func configuredTableView() -> UITableView {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine

        return tableView
    }

    private func configuredInfoHeaderView() -> UserInfoHeaderView {
        let view = UserInfoHeaderView()

        return view
    }
}

extension SettingsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    }


}

extension SettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

    }
}
