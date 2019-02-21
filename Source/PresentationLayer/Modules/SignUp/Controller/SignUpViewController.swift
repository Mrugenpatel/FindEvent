//
//  SignUpViewController.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit
import CoreLocation

class SignUpViewController: UIViewController, CLLocationManagerDelegate {

    // MARK: Properties

    private var locationManager: CLLocationManager!

    private var viewModel: SignUpControllerViewModelType!

    convenience init(viewModel: SignUpControllerViewModelType) {
        self.init()
        self.viewModel = viewModel
    }

    // MARK: Callbacks

    var doneCallback: EmptyClosure?

    // MARK: Views

    private lazy var selectUserAvatarView = SelectUserAvatarView()

    // MARK: Configuration

    override func configureView() {
        super.configureView()
    }

    override func configureViewModel() {
        super.configureViewModel()
        //        selectUserAvatarView.setTitle = viewModel.selectUserAvatarViewTitle
        //        rootView.selectUserAvatarView.didSelectImage = { [unowned self] in
        //            ImagePicker { picker in
        //                picker.didPickImage = { [unowned self] image in
        //                    self.rootView.selectUserAvatarView.setImage = image
        //                }
        //                }.show(from: self)
        //        }
        //        viewModel.userLocation = { [unowned self] latitude, longtitude in
        //            self.viewModel.userLocationData = (latitude,longtitude)
        //        }
        //        selectUserAvatarView.userImage = { [unowned self] image in
        //            self.viewModel.userImageData = image
        //        }
        //        didTouchSignUpViaEmail = { [unowned self] in
        //            self.viewModel.signUpViaEmail()
        //        }
    }

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        configureView()
        configureViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupNavigationBar()
    }

    // MARK: Setup

    private func setupNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = ViewConfig.Colors.background
    }

    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 200
        locationManager.startUpdatingLocation()
    }

    private func setupSelectUserAvatarView() {
       viewModel.
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        viewModel.geocodeLocationData(withLatitude: String(locations[0].coordinate.latitude), withLongitude: String(locations[0].coordinate.longitude))

        //viewModel.userLocation?(String(locations[0].coordinate.latitude),String(locations[0].coordinate.longitude))
        locationManager.stopUpdatingLocation()
    }
}


//// MARK: - Properties
//// MARK: Callbacks
//

//
//// MARK: Views
//
//lazy var selectUserAvatarView = SelectUserAvatarView()
//
//lazy var signUpEmailButton = configuredEmailButton()
//
//// MARK: - UI
//// MARK: Configuration
//
//override func configure() {
//    super.configure()
//    attachUserAvatarView()
//    attachEmailButton()
//}
//
//private func configuredEmailButton() -> Button {
//    let button = Button()
//    button.didTouchUpInside = { [unowned self] in
//        self.didTouchSignUpViaEmail?()
//    }
//    return button
//}
//
//private func attachUserAvatarView() {
//    containerView.addSubview(selectUserAvatarView)
//    selectUserAvatarView.snp.makeConstraints { make in
//        make.center.equalToSuperview()
//        make.width.equalTo(160)
//        make.height.equalTo(160)
//    }
//}
//
//private func attachEmailButton() {
//    containerView.addSubview(signUpEmailButton)
//    signUpEmailButton.snp.makeConstraints { make in
//        make.left.right.bottom.equalToSuperview()
//        make.height.equalTo(50)
//    }
//}
