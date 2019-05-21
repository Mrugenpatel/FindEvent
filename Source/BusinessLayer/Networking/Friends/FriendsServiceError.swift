//
//  FriendsServiceError.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 5/19/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation
import Firebase

enum FriendsServiceError {
    case unknown
    case emptyId
    case alreadyExists
    case notFound
    case unavailable
    case resourceExhausted
    case isEmpty
    case mappingFailed
    case requestError(String)

    public static func getError(from error: Error) -> FriendsServiceError {
        guard let userError = error as NSError?,
            let fireBaseError = FirestoreErrorCode(rawValue: userError.code) else {
                return  .unknown
        }

        switch fireBaseError {
        case .notFound: return .notFound
        case .alreadyExists: return .alreadyExists
        case .unavailable: return .unavailable
        case .resourceExhausted: return .resourceExhausted
        default:
            return .requestError(userError.description)
        }
    }
}
