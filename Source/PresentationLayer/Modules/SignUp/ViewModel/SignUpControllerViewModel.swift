//
//  SignUpControllerViewModel.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit
import CoreLocation

protocol SignUpControllerViewModelType {
    var selectUserAvatarViewTitle: String { get }
    var didTouchSignUpViaFB: EmptyClosure? { get set }
    var didTouchSignUpViaEmail: EmptyClosure? { get set }
    func geocodeLocationData(
        withLatitude latitude: String,
        withLongitude longitude: String
    )
}

class SignUpControllerViewModel: SignUpControllerViewModelType {

    private struct Strings {
        static let selectUserAvatarViewTitle = NSLocalizedString("Add", comment: "")
    }

    // MARK: Properties

    selectUserAvatarViewTitle = Strings.selectUserAvatarViewTitle

    private let emailAuthService: EmailAuthService

    private let facebookAuthService: FacebookAuthService

    // MARK: Callbacks

    var userImageData: UIImage?

    var userLocation: ((String,String) -> (Void))?

    var userLocationData: (latitude: String, longtitude: String)?

    var didTouchSignUpViaFB: EmptyClosure?

    var didTouchSignUpViaEmail: EmptyClosure?

    init(emailAuthService: EmailAuthService, facebookAuthService: FacebookAuthService) {
        self.emailAuthService = emailAuthService
        self.facebookAuthService = facebookAuthService
    }

    // MARK: Actions

    func signUpViaEmail() {

        guard let userImageData = userImageData else {return}
        guard let userLocation = userLocationData else {return}
        EmailAuthService(userService: UserService(), imageService: ImageService()).signUp(
            withName: "Yurii Tsymbala",
            withEmail: "lelele1100.71.168.87le@gmail.com",
            withPassword: "lelelle",
            withUserImg: userImageData,
            withLatitude: userLocation.latitude,
            withLongtitude: userLocation.longtitude) { responseResult in
                switch responseResult {
                case .success(_):
                    print("Success")
                case .failure(let error):
                    print(error)
                }
        }
    }

    func geocodeLocationData(
        withLatitude latitude: String,
        withLongitude longitude: String
        ) {
        var center = CLLocationCoordinate2D()
        let lat = Double("\(latitude)")!
        let lon = Double("\(longitude)")!
        let ceo = CLGeocoder()
        center.latitude = lat
        center.longitude = lon

        let loc = CLLocation(latitude:center.latitude, longitude: center.longitude)

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
}

