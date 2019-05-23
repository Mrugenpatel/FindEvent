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
    private lazy var friendsActivityIndicator = configuredActivityIndicator()
    private lazy var requestsTableView = configuredRequestsTableView()
    private lazy var requestsActivityIndicator = configuredActivityIndicator()
    private lazy var sentTableView = configuredSentTableView()
    private lazy var sentActivityIndicator = configuredActivityIndicator()
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
        // fetch All info
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
//        attachFriendsActivityIndicator()
//        attachRequestsActivityIndicator()
//        attachSentActivityIndicator()
//        attachSortTypeButton()
    }
    
    override func configureViewModel() {
        super.configureViewModel()

        // колбеки які релоадять тейблвюхи (присилається фолс по дефолту і крутяться крутілки, якшо тру то зупиняютсья крутілки і релоадиться)
        // колбек який крутить крутілку тру/фолс поки методи виконуються
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
    
    private func configuredActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        
        return activityIndicator
        
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
    
    private func attachFriendsTableView() {
        containerView.addSubview(friendsTableView)
        
        friendsTableView.snp.makeConstraints { maker in
            maker.top.equalTo(segmentControl.snp.bottom).offset(5)
            maker.left.right.bottom.equalToSuperview().inset(8)
        }
    }
    
    private func attachMapView() {
        friendsTableView.addSubview(friendsMapView)
        
        friendsMapView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
    
    private func attachRequestsTableView() {
        containerView.addSubview(requestsTableView)
        
        requestsTableView.snp.makeConstraints { maker in
            maker.top.equalTo(segmentControl.snp.bottom).offset(5)
            maker.left.right.bottom.equalToSuperview().inset(8)
        }
    }
    
    private func attachSentTableView() {
        containerView.addSubview(sentTableView)
        
        sentTableView.snp.makeConstraints { maker in
            maker.top.equalTo(segmentControl.snp.bottom).offset(5)
            maker.left.right.bottom.equalToSuperview().inset(8)
        }
    }
    
    private func attachFriendsActivityIndicator() {
        friendsTableView.addSubview(friendsActivityIndicator)
        
        friendsActivityIndicator.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
    }
    
    private func attachRequestsActivityIndicator() {
        requestsTableView.addSubview(requestsActivityIndicator)
        
        requestsActivityIndicator.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
    }
    
    private func attachSentActivityIndicator() {
        sentTableView.addSubview(sentActivityIndicator)
        
        sentActivityIndicator.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
    }
    
    private func attachSortTypeButton() {
        containerView.addSubview(sortTypeButton)
        
        sortTypeButton.snp.makeConstraints { maker in
            maker.right.bottom.equalToSuperview().inset(20)
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
            friendsTableView.isHidden = false
            requestsTableView.isHidden = true
            sentTableView.isHidden = true
        case 1:
            friendsTableView.isHidden = true
            requestsTableView.isHidden = false
            sentTableView.isHidden = true
        case 2:
            friendsTableView.isHidden = true
            requestsTableView.isHidden = true
            sentTableView.isHidden = false
        default:
            break
        }
    }
}
