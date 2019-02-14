//
//  User.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/9/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation

class User {
    private enum Constants: String {
        case id
        case name
        case email
        case avatarImgURL
        case latitude
        case longtitude
    }

    let id: String?
    var name: String?
    let email: String?
    var avatarImgURL: String?
    var latitude: String?
    var longtitude: String?

    init?(user: [String: Any]) {
        guard let id = user[Constants.id.rawValue] as? String else { return nil }
        self.id = id
        guard let name = user[Constants.name.rawValue] as? String else { return nil }
        self.name = name
        guard let email = user[Constants.email.rawValue] as? String else { return nil }
        self.email = email
        guard let avatarImgURL = user[Constants.avatarImgURL.rawValue] as? String else { return nil }
        self.avatarImgURL = avatarImgURL
        guard let latitude = user[Constants.latitude.rawValue] as? String else { return nil }
        self.latitude = latitude
        guard let longtitude = user[Constants.longtitude.rawValue] as? String else { return nil }
        self.longtitude = longtitude
    }

    init(id: String,
         name: String,
         email: String,
         avatarImgURL: String,
         latitude: String,
         longtitude: String
        ) {
        self.id = id
        self.name = name
        self.email = email
        self.avatarImgURL = avatarImgURL
        self.latitude = latitude
        self.longtitude = longtitude
    }

    func data() -> [String: Any] {
        return [
            Constants.id.rawValue: id as Any,
            Constants.name.rawValue: name as Any,
            Constants.email.rawValue: email as Any,
            Constants.avatarImgURL.rawValue: avatarImgURL as Any,
            Constants.latitude.rawValue: latitude as Any,
            Constants.longtitude.rawValue: longtitude as Any
        ]
    }
}

