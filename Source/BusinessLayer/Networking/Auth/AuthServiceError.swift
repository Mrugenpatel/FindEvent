//
//  AuthServiceError.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/8/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation
import Firebase

enum AuthServiceError: Error {
    case invalidCredentials
    case emailAlreadyExists
    case invalidEmail
    case wrongPassword
    case userNotFound
    case networkError(NSError)
    case credentialAlreadyInUse
    case weakPassword
    case internalError(NSError)
    case unknwownError(String)
    case internalInconsistency
    case failedToCreateUser
    case failedToGetUser
    case emptyPassword
    case failedToChangePassword

    public static func getError(error: Error) -> AuthServiceError {
        guard let authError = error as NSError?,
            let firebaseError = AuthErrorCode(rawValue: authError.code)
            else { return .unknwownError("Unknown Error") }
        switch firebaseError {
        case .invalidCredential: return .invalidCredentials
        case .emailAlreadyInUse: return .emailAlreadyExists
        case .invalidEmail: return .invalidEmail
        case .wrongPassword: return .wrongPassword
        case .userNotFound: return .userNotFound
        case .networkError: return .networkError(authError)
        case .credentialAlreadyInUse: return .credentialAlreadyInUse
        case .weakPassword: return .weakPassword
        default :
            return .internalError(authError)
        }
    }
}
