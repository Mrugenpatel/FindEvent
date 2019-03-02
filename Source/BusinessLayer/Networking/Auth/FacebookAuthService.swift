//
//  FacebookAuthService.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/6/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol FacebookAuthServiceType: AuthServiceType {
    
    func signUp(
        withUserImg img: UIImage?,
        completion: @escaping AuthResult
    )
    
    func signIn(
        completion: @escaping AuthResult
    )
}

class FacebookAuthService: AuthServiceType, FacebookAuthServiceType {

    let firebaseAuth = Auth.auth()

    private var currentFirebaseUser: FirebaseAuth.User? {
        return firebaseAuth.currentUser
    }

    var currentUserId: String? {
        guard let firUserId = currentFirebaseUser?.uid else { return nil }
        return firUserId
    }
    
    func signUp(
        withUserImg img: UIImage?,
        completion: @escaping AuthResult
        ) { // if image(Optional) -> set imageUrl from Facebook
        
    }
    
    func signIn(
        completion: @escaping AuthResult
        ) {
        
    }
    
    func signOut(
        completion: @escaping (Result<Bool, AuthServiceError>) -> Void
        ) {
        
    }
}
