//
//  AuthServiceBase.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/14/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol AuthServiceType {

    typealias AuthResult = (Result<User, AuthServiceError>) -> Void

    func signOut(
        completion: @escaping (Result<Bool, AuthServiceError>) -> Void
    )

    var currentUserId: String? { get }
}


class AuthServiceBase: AuthServiceType {

    func signOut(completion: @escaping (Result<Bool, AuthServiceError>) -> Void) {
    }

    let firebaseAuth = Auth.auth()

    private var currentFirebaseUser: FirebaseAuth.User? {
        return firebaseAuth.currentUser
    }

    var currentUserId: String? {
        guard let firUserId = currentFirebaseUser?.uid else { return nil }
        return firUserId
    }
}
