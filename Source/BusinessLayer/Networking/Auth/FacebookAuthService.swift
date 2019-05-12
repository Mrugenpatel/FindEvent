//
//  FacebookAuthService.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/6/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation
import FirebaseAuth
import FacebookCore
import FacebookLogin

protocol FacebookAuthServiceType: AuthServiceType {
    
    func signUp(
        viewController: UIViewController,
        withUserImg img: UIImage?,
        completion: @escaping AuthResult
    )
    
    func signIn(
        completion: @escaping AuthResult
    )
}

class FacebookAuthService: FacebookAuthServiceType {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        FBSDKApplicationDelegate.sharedInstance()?.application(application,
                                                               didFinishLaunchingWithOptions: launchOptions)
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance()?.application(app,
                                                                      open: url,
                                                                      options: options) ?? false
    }

    let firebaseAuth = Auth.auth()

    private var currentFirebaseUser: FirebaseAuth.User? {
        return firebaseAuth.currentUser
    }

    var currentUserId: String? {
        guard let firUserId = currentFirebaseUser?.uid else { return nil }
        return firUserId
    }
    
    func signUp(
        viewController: UIViewController,
        withUserImg img: UIImage?,
        completion: @escaping AuthResult
        ) { // if image(Optional) -> set imageUrl from Facebook

        LoginManager().logIn(
            readPermissions: [.publicProfile, .email],
            viewController: viewController) { [weak self] responseResult in
                switch responseResult {

                case .success(let grantedPermissions, let declinedPermissions, let token):
                    self?.signInToFirebase()
                case .cancelled:
                    completion(Result.failure(AuthServiceError.failedToGetUser))
                case .failed(let error):
                    completion(Result.failure(AuthServiceError.getError(error: error)))

                }
        }

    }

    private func signInToFirebase() {
        guard let authToken = AccessToken.current?.authenticationToken else { return }
        let credential = FacebookAuthProvider.credential(withAccessToken: authToken)
        firebaseAuth.signInAndRetrieveData(with: credential) { (responseResult, responseError) in
            guard responseError == nil else { return }


        }
    }

    private func fetchFacebookUser() {
        
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
