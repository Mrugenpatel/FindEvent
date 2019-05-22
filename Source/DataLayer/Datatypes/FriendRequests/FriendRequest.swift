//
//  FriendRequests.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 5/20/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation

class FriendRequest {
    private enum Constants: String {
        case id
        case receiver
        case sender
        case status
    }

    let id: String?
    var receiver: String?
    var sender: String?
    var status: String?

    init?(friendRequest: [String: Any]) {
        guard let id = friendRequest[Constants.id.rawValue] as? String else { return nil }
        self.id = id
        guard let receiver = friendRequest[Constants.receiver.rawValue] as? String else { return nil }
        self.receiver = receiver
        guard let sender = friendRequest[Constants.sender.rawValue] as? String else { return nil }
        self.sender = sender
        guard let status = friendRequest[Constants.status.rawValue] as? String else { return nil }
        self.status = status
    }

    init(id: String?,
         receiver: String?,
         sender: String?,
         status: String?
        ) {
        self.id = id
        self.receiver = receiver
        self.sender = sender
        self.status = status
    }

    func data() -> [String: Any] {
        return [
            Constants.id.rawValue: id as Any,
            Constants.receiver.rawValue: receiver as Any,
            Constants.sender.rawValue: sender as Any,
            Constants.status.rawValue: status as Any
        ]
    }
}






