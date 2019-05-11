//
//  UserDefaultsService.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation

final class UserDefaultsService {

    private let userDefaults = UserDefaults.standard

    private enum Keys: String {
        case keyUserLogin
        case keyShareCurrentLocation
    }

    var isUserLogin: Bool {
        get {
            let isUserLogin = userDefaults.bool(forKey: Keys.keyUserLogin.rawValue)
            return isUserLogin
        }
        set(userLoginState) {
            userDefaults.set(userLoginState, forKey: Keys.keyUserLogin.rawValue)
            userDefaults.synchronize()
        }
    }

    var shareCurrentLocation: Bool {
        get {
            let shareCurrentLocation = userDefaults.bool(forKey: Keys.keyShareCurrentLocation.rawValue)
            return shareCurrentLocation
        }
        set(shareCurrentLocation) {
            userDefaults.set(shareCurrentLocation, forKey: Keys.keyShareCurrentLocation.rawValue)
            userDefaults.synchronize()
        }
    }
}

