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

    private var viewModel: SettingsControllerViewModel!

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
        attachInfoHeaderView()
        attachTableView()
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
        tableView.backgroundColor = ViewConfig.Colors.dark
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(ofType: SettingsTableViewCell.self)

        return tableView
    }

    private func configuredInfoHeaderView() -> UserInfoHeaderView {
        let view = UserInfoHeaderView()
        view.configure(viewModel: UserInfoHeaderViewModel(
            image: R.image.profilePlaceholder(),
            name: "Yurii Tsymbala",
            location: "Lviv, Ukraine"
        ))

        return view
    }

    // MARK: Attachments

    private func attachInfoHeaderView() {
        containerView.addSubview(infoHeaderView)

        infoHeaderView.snp.makeConstraints { maker in
            maker.left.right.top.equalToSuperview()
            maker.height.equalTo(120)
        }
    }

    private func attachTableView() {
        containerView.addSubview(tableView)

        tableView.snp.makeConstraints { maker in
            maker.top.equalTo(infoHeaderView.snp.bottom)
            maker.left.right.bottom.equalToSuperview()
        }
    }
}

extension SettingsViewController: UITableViewDataSource {

    func numberOfSections(
        in tableView: UITableView
        ) -> Int {
        return viewModel.numberOfSections
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
        ) -> Int {
        switch viewModel.sections[section] {
        case .firstSection:
            return 3
        case .secondSection:
            return 2
        }
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {

        let cell: SettingsTableViewCell = tableView.dequeueCell(at: indexPath)
        cell.configure(withViewModel: viewModel.getCellViewModel(atIndex: indexPath.row))
        return cell
    }

    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
        ) -> UIView? {
        let backgroundView = UIView()
        backgroundView.backgroundColor = ViewConfig.Colors.dark

        return backgroundView
    }
}


extension SettingsViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
        ) {
        viewModel.selectCellViewModel(atIndex: indexPath.row)
    }


    func tableView(
        _ tableView: UITableView,
        estimatedHeightForHeaderInSection section: Int
        ) -> CGFloat {
        return 30
    }

    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
        ) -> CGFloat {
        return 30
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
        ) -> CGFloat {
        return 60
    }

    func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
        ) -> CGFloat {
        return 60
    }
}
