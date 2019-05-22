//
//  FriendsViewController.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit
import MapKit

class FriendsViewController: UIViewController {
    
    private var viewModel: FriendsControllerViewModel?
    
    convenience init(viewModel: FriendsControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    // MARK: - Callbacks
    
    // MARK: - Views
    
    private lazy var segmentControl = configuredSegmentControl()
    private lazy var friendsMapView = configuredMapView()
    private lazy var friendsTableView = configuredFriendsTableView()
    private lazy var requestsTableView = configuredRequestsTableView()
    private lazy var sentTableView = configuredSentTableView()
    private lazy var sortTypeButton = configuredSortTypeButton()
    
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
          attachSegmentControl()
//        attachFriendsTableView()
//        attachMapView()
//        attachRequestsTableView()
//        attachSentTableView()
//        attachSortTypeButton()
    }
    
    override func configureViewModel() {
        super.configureViewModel()
    }
    
    private func configuredNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addFriends))
    }
    
    private func configuredSegmentControl() -> SegmentControl {
        let segmentControl = SegmentControl()
         segmentControl.insertSegment(withTitle: "Friends", at: 0, animated: false)
         segmentControl.insertSegment(withTitle: "Requests", at: 1, animated: false)
         segmentControl.insertSegment(withTitle: "Sent", at: 2, animated: false)
         segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
        return segmentControl
    }
    
    private func configuredMapView() -> MKMapView {
        let mapView = MKMapView()
        
        return mapView
    }
    
    private func configuredFriendsTableView() -> UITableView {
        let tableView = UITableView()
        
        return tableView
    }
    
    private func configuredRequestsTableView() -> UITableView {
        let tableView = UITableView()
        
        return tableView
    }
    
    private func configuredSentTableView() -> UITableView {
        let tableView = UITableView()
        
        return tableView
    }
    
    private func configuredSortTypeButton() -> Button {
        let button = Button()
        
        return button
    }
    
    // MARK: - Attachments
    
    private func attachSegmentControl() {
        containerView.addSubview(segmentControl)
        
        segmentControl.snp.makeConstraints { maker in
            maker.left.right.top.equalToSuperview().inset(8)
            maker.height.equalTo(40)
        }
    }
    
    private func attachMapView() {
        
    }
    
    private func attachFriendsTableView() {
        
    }
    
    private func attachRequestsTableView() {
        
    }
    
    private func attachSentTableView() {
        
    }
    
    private func attachSortTypeButton() {
        containerView.addSubview(sortTypeButton)
        
        sortTypeButton.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.height.width.equalTo(50)
        }
        
    }
    
    
    // MARK: Actions
    
    @objc private func addFriends() {
        //viewModel.saveEditedInfo()
    }
    
    @objc private func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            print("iOS")
        case 1:
            print("Android")
        case 2:
            print("Android")
        default:
            break
        }
    }
}
