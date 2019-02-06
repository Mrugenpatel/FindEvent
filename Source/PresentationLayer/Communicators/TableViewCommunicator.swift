//
//  TableViewCommunicator.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/6/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class TableViewCommunicator<
    TableView: UITableView,
    ContentViewModel: ViewModel
    >:  NSObject,
    UITableViewDataSource,
UITableViewDelegate {

    // MARK: - Properties

    weak var tableView: UITableView?
    let viewModel: ContentViewModel


    // MARK: - Initialization

    init(
        tableView: TableView,
        viewModel: ContentViewModel
        ) {
        self.tableView = tableView
        self.viewModel = viewModel

        super.init()

        configureTableView()
        reloadData()
    }


    // MARK: - Appearance

    func reloadData() {
        tableView?.reloadData()
    }

    func remove(
        at indexPath: IndexPath,
        animation: UITableView.RowAnimation = .fade
        ) {
        tableView?.beginUpdates()
        tableView?.deleteRows(at: [indexPath], with: animation)
        tableView?.endUpdates()
    }

    func reload(
        at indexPath: IndexPath,
        animation: UITableView.RowAnimation = .none
        ) {
        tableView?.beginUpdates()
        tableView?.reloadRows(at: [indexPath], with: animation)
        tableView?.endUpdates()
    }


    // MARK: - Configuration

    func configureTableView() {
        tableView?.dataSource = self
        tableView?.delegate = self
    }


    // MARK: - UITableViewDataSource

    func numberOfSections(
        in tableView: UITableView
        ) -> Int {
        return 1
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
        ) -> Int {
        notImplementedFatalError()
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {
        notImplementedFatalError()
    }

    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
        ) -> UIView? {
        return nil
    }

    func sectionIndexTitles(
        for tableView: UITableView
        ) -> [String]? {
        return nil
    }


    // MARK: - UITableViewDelegate

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
        ) {

    }

    func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
        ) -> CGFloat {
        return 0
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
        ) -> CGFloat {
        return 0
    }

    func tableView(
        _ tableView: UITableView,
        estimatedHeightForHeaderInSection section: Int
        ) -> CGFloat {
        return 0
    }

    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
        ) -> CGFloat {
        return 0
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
        ) {

    }

    func tableView(
        _ tableView: UITableView,
        willDisplayHeaderView view: UIView,
        forSection section: Int
        ) {
        view.tintColor = .white
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
