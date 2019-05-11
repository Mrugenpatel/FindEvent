//
//  ProfileSettingsViewController.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 3/30/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit
import SVProgressHUD
import Position
import CoreLocation

final class ProfileSettingsViewController: UIViewController {
    private struct Constants {
        static let heightForAvatarRow: CGFloat = 125
        static let heightForNameRow: CGFloat = 40
        static let heightForLocationRow: CGFloat = 40
        static let heightForDescriptionRow: CGFloat = 40
        static let heightForFooterInSection: CGFloat = 30
    }

    private var viewModel: ProfileSettingsControllerViewModel!

    convenience init(viewModel: ProfileSettingsControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    // MARK: Callbacks

    var doneCallback: EmptyClosure?

    // MARK: Views

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
        attachTableView()
    }

    override func configureViewModel() {
        super.configureViewModel()
        viewModel.startingLogout = { [unowned self] in
            self.doneCallback?()
        }
        viewModel.dismissVC = { [weak self] in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        viewModel.didCatchError = { [weak self] error in
            DispatchQueue.main.async {
                self?.showError(error: error)
            }
        }
        viewModel.isAnimating = { isAnimating in
            DispatchQueue.main.async {
                //isAnimating ? SVProgressHUD.show() : SVProgressHUD.dismiss()
            }
        }
        viewModel.getUserInfo { [weak self] userInfo in
            guard let userInfo = userInfo else { return }
            self?.viewModel.editedUserInfo = userInfo
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    private func configuredNavigationBar() {
        navigationItem.title = "Edit Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: #selector(save))
    }

    private func configuredTableView() -> UITableView {
        let tableView = UITableView()
        tableView.backgroundColor = ViewConfig.Colors.dark
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(ofType: SettingsAvatarCell.self)
        tableView.registerCell(ofType: SettingsNameCell.self)
        tableView.registerCell(ofType: SettingsLocationCell.self)
        tableView.registerCell(ofType: SettingsDecriptionCell.self)
        tableView.registerCell(ofType: SettingsLogoutCell.self)

        return tableView
    }

    // MARK: - Attachments

    private func attachTableView() {
        containerView.addSubview(tableView)

        tableView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }

    // MARK: Actions

    @objc func save() {
        viewModel.saveEditedInfo()
    }

    private func showError(error: String) {
        SVProgressHUD.showError(withStatus: error)
    }
}

extension ProfileSettingsViewController: UITableViewDataSource {

    func numberOfSections(
        in tableView: UITableView
        ) -> Int {
        return viewModel.numberOfSections
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
        ) -> Int {
        return 1
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {
        switch viewModel.sections[indexPath.section] {
        case .avatarSection:
            let cell: SettingsAvatarCell = tableView.dequeueCell(at: indexPath)
            cell.configure(avatarImage: viewModel.editedUserInfo.avatarImage)
            cell.selectAvatarView.didSelectImage = { [unowned self] in
                ImagePicker { picker in
                    picker.didPickImage = { [unowned self] image in
                        cell.configure(avatarImage: image)
                        self.viewModel.updatedImage = image
                    }
                    }.show(from: self)
            }
            return cell
        case .nameSection:
            let cell: SettingsNameCell = tableView.dequeueCell(at: indexPath)
            cell.configure(name: viewModel.editedUserInfo.name)
            cell.editedName = { [unowned self] name in
                self.viewModel.editedUserInfo.name = name
            }
            return cell
        case .locationSection:
            let cell: SettingsLocationCell = tableView.dequeueCell(at: indexPath)
            cell.configure(location: viewModel.editedUserInfo.coordinate)

            cell.showLocation = { [unowned self] isShowing in
                switch isShowing {
                case true:
                    self.viewModel.observeLocation(completion: { isUpdated in
                        isUpdated ? cell.configure(location: self.viewModel.editedUserInfo.coordinate) :
                            cell.configure(location: self.viewModel.editedUserInfo.coordinate)
                    })
                case false:
                    self.viewModel.editedUserInfo.coordinate = nil
                    cell.configure(location: nil)
                }
            }

            cell.showMap = { [unowned self] in
                // present map VC
            }
            return cell
        case .descriptionSection:
            let cell: SettingsDecriptionCell = tableView.dequeueCell(at: indexPath)
            cell.configure(description: viewModel.editedUserInfo.description)
            cell.editedDescription = { [unowned self] description in
                self.viewModel.editedUserInfo.description = description
            }
            return cell
        case .logoutSection:
            let cell: SettingsLogoutCell = tableView.dequeueCell(at: indexPath)
            cell.logout = { [unowned self] in
                self.viewModel.logout()
            }
            return cell
        }
    }

    func tableView(
        _ tableView: UITableView,
        viewForFooterInSection section: Int
        ) -> UIView? {
        let backgroundView = UIView()
        backgroundView.backgroundColor = ViewConfig.Colors.dark

        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = ViewConfig.Fonts.boldItalic(of: 12)
        label.textColor = ViewConfig.Colors.white
        label.text = viewModel.sections[section].rawValue

        backgroundView.addSubview(label)

        label.snp.makeConstraints { maker in
            maker.left.right.top.equalToSuperview().inset(5)
        }

        return backgroundView
    }
}

extension ProfileSettingsViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        estimatedHeightForFooterInSection section: Int
        ) -> CGFloat {
        return Constants.heightForFooterInSection
    }

    func tableView(
        _ tableView: UITableView,
        heightForFooterInSection section: Int
        ) -> CGFloat {
        return Constants.heightForFooterInSection
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
        ) -> CGFloat {
        switch viewModel.sections[indexPath.section] {
        case .avatarSection:
            return Constants.heightForAvatarRow
        case .nameSection:
            return Constants.heightForNameRow
        case .locationSection:
            return Constants.heightForLocationRow
        case .descriptionSection:
            return Constants.heightForDescriptionRow
        case .logoutSection:
            return Constants.heightForDescriptionRow
        }
    }

    func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
        ) -> CGFloat {
        switch viewModel.sections[indexPath.section] {
        case .avatarSection:
            return Constants.heightForAvatarRow
        case .nameSection:
            return Constants.heightForNameRow
        case .locationSection:
            return Constants.heightForLocationRow
        case .descriptionSection:
            return Constants.heightForDescriptionRow
        case .logoutSection:
            return Constants.heightForDescriptionRow
        }
    }
}


