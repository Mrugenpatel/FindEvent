//
//  UserInputError.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/6/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation

enum UserInputError: Error {
    case emptyUsername
    case emptyEmail
    case emptyPassword
    case shortPassword
    case invalidEmail
}

extension UserInputError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptyUsername:
            return "Please enter username"
        case .emptyEmail:
            return "Please enter Email"
        case .emptyPassword:
            return "Please enter password"
        case .shortPassword:
            return "Password must contain at least \(UserInputValidator.minimumPasswordLength) symbols"
        case .invalidEmail:
            return "Invalid Email"
        }
    }
}

