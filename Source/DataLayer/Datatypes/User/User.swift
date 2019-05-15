//
//  User.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/9/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation
import FirebaseFirestore

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
        case coordinate
        case lastOnlineDate
        case description
        case friends
    }

    let id: String?
    var name: String?
    let email: String?
    var avatarImgURL: String?
    var coordinate: GeoPoint?
    var lastOnlineDate: Bool?
    var description: String?
    var friends: [DocumentReference]?

    init?(user: [String: Any]) {
        guard let id = user[Constants.id.rawValue] as? String else { return nil }
        self.id = id
        guard let name = user[Constants.name.rawValue] as? String else { return nil }
        self.name = name
        guard let email = user[Constants.email.rawValue] as? String else { return nil }
        self.email = email
        guard let avatarImgURL = user[Constants.avatarImgURL.rawValue] as? String else { return nil }
        self.avatarImgURL = avatarImgURL
        if let coordinate = user[Constants.coordinate.rawValue] as? GeoPoint {
            self.coordinate = GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
        guard let lastOnlineDate = user[Constants.lastOnlineDate.rawValue] as? Bool else { return nil }
        self.lastOnlineDate = lastOnlineDate
        guard let description = user[Constants.description.rawValue] as? String else { return nil }
        self.description = description
        guard let friends = user[Constants.friends.rawValue] as? [DocumentReference] else { return nil }
        self.friends = friends
    }

    init(id: String?,
         name: String?,
         email: String?,
         avatarImgURL: String?,
         coordinate: GeoPoint?,
         lastOnlineDate: Bool?,
         description: String?,
         friends: [DocumentReference]?
        ) {
        self.id = id
        self.name = name
        self.email = email
        self.avatarImgURL = avatarImgURL
        self.coordinate = coordinate
        self.lastOnlineDate = lastOnlineDate
        self.description = description
        self.friends = friends
    }

    func data() -> [String: Any] {
        return [
            Constants.id.rawValue: id as Any,
            Constants.name.rawValue: name as Any,
            Constants.email.rawValue: email as Any,
            Constants.avatarImgURL.rawValue: avatarImgURL as Any,
            Constants.coordinate.rawValue: coordinate as Any,
            Constants.lastOnlineDate.rawValue: lastOnlineDate as Any,
            Constants.description.rawValue: description as Any,
            Constants.friends.rawValue: friends as Any
        ]
    }
}

