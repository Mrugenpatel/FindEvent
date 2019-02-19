//
//  SignUpControllerViewModel.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class SignUpControllerViewModel {

    private let emailAuthService: EmailAuthService
    private let facebookAuthService: FacebookAuthService

    var userImageData: UIImage?
    var userLocation: ((String,String) -> (Void))?
    var userLocationData: (latitude: String,longtitude: String)?

     init(emailAuthService: EmailAuthService, facebookAuthService: FacebookAuthService) {
        self.emailAuthService = emailAuthService
        self.facebookAuthService = facebookAuthService

    }

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
}

