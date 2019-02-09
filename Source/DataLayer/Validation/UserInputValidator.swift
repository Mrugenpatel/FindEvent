//
//  UserInputValidator.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/6/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation

class UserInputValidator {
    static let minimumPasswordLength = 6

    func validateSignIn(
        email: String?,
        password: String?) throws -> (email: String, password: String) {

        let email = try validateEmail(email)
        let password = try validatePassword(password)
        return (email: email, password: password)
    }

    func validateSignUp(
        name: String?,
        email: String?,
        password: String?) throws -> (name: String, email: String, password: String) {

        let name = try validateName(name)
        let email = try validateEmail(email)
        let password = try validatePassword(password)
        return (name: name, email: email, password: password)
    }

    func validateName(_ username: String?) throws -> String {
        guard
            let username = username,
            !username.isEmpty else {
                throw UserInputError.emptyUsername
        }

        return username
    }

    func validateEmail(_ email: String?) throws -> String {
        guard
            let email = email,
            !email.isEmpty else {
                throw UserInputError.emptyEmail
        }

        guard email.isValidEmail() else {
            throw UserInputError.invalidEmail
        }

        return email
    }

    func validatePassword(_ password: String?) throws -> String {
        guard
            let password = password,
            !password.isEmpty else {
                throw UserInputError.emptyPassword
        }

        guard password.count >= UserInputValidator.minimumPasswordLength else {
            throw UserInputError.shortPassword
        }

        return password
    }
}

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: self)
    }
}
