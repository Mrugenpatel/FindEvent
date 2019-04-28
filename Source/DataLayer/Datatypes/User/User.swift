//
//  User.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/9/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation

/* User
 id
 name
 email
 avatarImgUrl
 latitude
 longtitude
 lastOnlineDate - "Update with 1 minute interval" , observe it and check if (current date - lastOnlineDate) <= 2 -> user is Online
 descriptionInfo - "I am 20 years old iOS deverloper from Lviv"
 */


class User {
    private enum Constants: String {
        case id
        case name
        case email
        case avatarImgURL
        case latitude
        case longitude
        case lastOnlineDate
        case description
    }

    let id: String?
    var name: String?
    let email: String?
    var avatarImgURL: String?
    var latitude: String?
    var longitude: String?
    var lastOnlineDate: Bool?
    var description: String?

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
        guard let longtitude = user[Constants.longitude.rawValue] as? String else { return nil }
        self.longitude = longtitude
        guard let lastOnlineDate = user[Constants.lastOnlineDate.rawValue] as? Bool else { return nil }
        self.lastOnlineDate = lastOnlineDate
        guard let description = user[Constants.description.rawValue] as? String else { return nil }
        self.description = description
    }

    init(id: String,
         name: String,
         email: String,
         avatarImgURL: String,
         latitude: String,
         longitude: String,
         isOnline: Bool,
         description: String
        ) {
        self.id = id
        self.name = name
        self.email = email
        self.avatarImgURL = avatarImgURL
        self.latitude = latitude
        self.longitude = longitude
        self.lastOnlineDate = isOnline
        self.description = description
    }

    func data() -> [String: Any] {
        return [
            Constants.id.rawValue: id as Any,
            Constants.name.rawValue: name as Any,
            Constants.email.rawValue: email as Any,
            Constants.avatarImgURL.rawValue: avatarImgURL as Any,
            Constants.latitude.rawValue: latitude as Any,
            Constants.longitude.rawValue: longitude as Any,
            Constants.lastOnlineDate.rawValue: lastOnlineDate as Any,
            Constants.description.rawValue: description as Any
        ]
    }
}

