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
        case location
    }

    let id: String?
    var name: String?
    let email: String?
    var avatarImgURL: String?
    var location: String? //Ukraine,Lviv

    init?(user: [String: Any]) {
        guard let id = user[Constants.id.rawValue] as? String else { return nil }
        self.id = id
        guard let name = user[Constants.name.rawValue] as? String else { return nil }
        self.name = name
        guard let email = user[Constants.email.rawValue] as? String else { return nil }
        self.email = email
        guard let avatarImgURL = user[Constants.avatarImgURL.rawValue] as? String else { return nil }
        self.avatarImgURL = avatarImgURL
        guard let location = user[Constants.location.rawValue] as? String else { return nil }
        self.location = location
    }

    init(id: String,
         name: String,
         email: String,
         avatarImgURL: String,
         location: String) {

        self.id = id
        self.name = name
        self.email = email
        self.avatarImgURL = avatarImgURL
        self.location = location

    }

    func data() -> [String: Any] {
        return [Constants.id.rawValue: id as Any,
                Constants.name.rawValue: name as Any,
                Constants.email.rawValue: email as Any,
                Constants.avatarImgURL.rawValue: avatarImgURL as Any,
                Constants.location.rawValue: location as Any]
    }
}

