//
//  SignUpViewController.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit
import CoreLocation

class SignUpViewController: Controller<
    SignUpControllerView,
    SignUpControllerViewModel
> , CLLocationManagerDelegate {

    // MARK: Properties

    var locationManager: CLLocationManager!

    // MARK: Callbacks
    var doneCallback: EmptyClosure?

    // MARK: Configuration

    override func configureView() {
        super.configureView()

        // MARK: SelectUserAvatarView

        rootView.selectUserAvatarView.setTitle = "ADD"
        rootView.selectUserAvatarView.didSelectImage = { [unowned self] in
            ImagePicker { picker in
                picker.didPickImage = { [unowned self] image in
                    self.rootView.selectUserAvatarView.setImage = image
                }
                }.show(from: self)
        }

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 200
        locationManager.startUpdatingLocation()

    }

    override func configureViewModel() {
        super.configureViewModel()
        viewModel.userLocation = { [unowned self] latitude, longtitude in
            self.viewModel.userLocationData = (latitude,longtitude)
        }
        rootView.selectUserAvatarView.userImage = { [unowned self] image in
            self.viewModel.userImageData = image
        }
        rootView.didTouchSignUpViaEmail = { [unowned self] in
           self.viewModel.signUpViaEmail()
        }
    }

    private func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon

        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]

                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country)
                    print(pm.locality)
                    print(pm.subLocality)
                    print(pm.thoroughfare)
                    print(pm.postalCode)
                    print(pm.subThoroughfare)
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }

                    print(addressString)
                }
        })
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        getAddressFromLatLon(pdblLatitude: String(locations[0].coordinate.latitude), withLongitude: String(locations[0].coordinate.longitude))

        viewModel.userLocation?(String(locations[0].coordinate.latitude),String(locations[0].coordinate.longitude))
        locationManager.stopUpdatingLocation()
    }
}
