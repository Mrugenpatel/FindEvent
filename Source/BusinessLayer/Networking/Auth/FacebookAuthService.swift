//
//  FacebookAuthService.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/6/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FacebookCore
import FacebookLogin
import FBSDKLoginKit
import SwiftyJSON

protocol FacebookAuthServiceType: AuthServiceType {
    
    func signUp(
        viewController: UIViewController,
        withUserImg img: UIImage?,
        withCoordinate coordinate: GeoPoint?,
        completion: @escaping AuthResult
    )
}

class FacebookAuthService: FacebookAuthServiceType {

    private let userService: UserService
    private let imageService: ImageService

    init(userService: UserService, imageService: ImageService) {
        self.userService = userService
        self.imageService = imageService
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
        withCoordinate coordinate: GeoPoint?,
        completion: @escaping AuthResult
        ) {
        LoginManager().logIn(readPermissions: [.publicProfile, .email], viewController: viewController) { [weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                guard let authenticationToken = AccessToken.current?.authenticationToken else {
                    completion(Result.failure(AuthServiceError.failedToCreateUser)); return }
                let facebookCredential = FacebookAuthProvider.credential(withAccessToken: authenticationToken)
                strongSelf.firebaseAuth.signInAndRetrieveData(with: facebookCredential) { (result, err) in
                    if let _ = err { completion(Result.failure(AuthServiceError.failedToCreateUser)); return }
                    strongSelf.fetchFacebookUser(
                        completion: completion,
                        withUserImg: img,
                        withCoordinate: coordinate
                    )
                }
            case .failed(_):
                completion(Result.failure(AuthServiceError.failedToCreateUser))
            case .cancelled:
                completion(Result.failure(AuthServiceError.failedToCreateUser))
            }
        }
    }
    
    private func fetchFacebookUser(
        completion: @escaping AuthResult,
        withUserImg img: UIImage?,
        withCoordinate coordinate: GeoPoint?
        ) {
        let graphRequestConnection = GraphRequestConnection()
        let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, name, picture.type(large)"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: .defaultVersion)
        graphRequestConnection.add(graphRequest, completion: { [weak self] (httpResponse, result) in
            switch result {
            case .success(response: let response):
                
                guard let currentUserID = self?.currentUserId else { completion(Result.failure(AuthServiceError.failedToCreateUser)); return }
                guard let responseDict = response.dictionaryValue else {
                    completion(Result.failure(AuthServiceError.failedToCreateUser)); return }
                let json = JSON(responseDict)
                guard
                    let name = json["name"].string,
                    let email = json["email"].string,
                    let profileImageFacebookUrl = json["picture"]["data"]["url"].string,
                    let url = URL(string: profileImageFacebookUrl)
                    else { completion(Result.failure(AuthServiceError.failedToCreateUser)); return }

                let currentUserDocument = Firestore.firestore().collection("users").whereField("id", isEqualTo: currentUserID)
                currentUserDocument.getDocuments(completion: { [weak self] (data,error) in
                    guard let strongSelf = self else {return}
                    if error == nil && data?.count == 1 {
                        strongSelf.userService.getById(
                            userId: currentUserID)
                        { responseResult in
                            switch responseResult {
                            case .success(let user):
                                completion(.success(user))
                            case .failure:
                                completion(.failure(.failedToGetUser))
                            }
                        }
                        return
                    } else {
                        if let image = img {
                            strongSelf.imageService.uploadImage(
                                image,
                                identifier: currentUserID)
                            { responsResult in

                                switch responsResult {

                                case .success(let url):
                                    let stringURL = url.absoluteString

                                    strongSelf.userService.create(
                                        user: User(
                                            id: currentUserID,
                                            name: name,
                                            email: email,
                                            avatarImgURL: stringURL,
                                            coordinate: coordinate,
                                            lastOnlineDate: true,
                                            description: ""
                                        ))
                                    { responseResult in

                                        switch responseResult {
                                        case .success(let userFromFiretore):
                                            completion(.success(userFromFiretore))
                                        case .failure:
                                            completion(.failure(.failedToCreateUser))
                                        }
                                    }

                                case .failure(_):
                                    completion(.failure(AuthServiceError.unknwownError("Image Uploading Failed =(")))
                                }
                            }
                        } else {
                            strongSelf.userService.create(
                                user: User(
                                    id: currentUserID,
                                    name: name,
                                    email: email,
                                    avatarImgURL: url.absoluteString,
                                    coordinate: coordinate,
                                    lastOnlineDate: true,
                                    description: ""
                                ))
                            { responseResult in

                                switch responseResult {
                                case .success(let userFromFiretore):
                                    completion(.success(userFromFiretore))
                                case .failure:
                                    completion(.failure(.failedToCreateUser))
                                }
                            }
                        }
                        return

                    }
                })
            case .failed(_):
                completion(Result.failure(AuthServiceError.failedToCreateUser))
                break
            }
        })
        graphRequestConnection.start()
    }

    
    func signOut(
        completion: @escaping (Result<Bool, AuthServiceError>) -> Void
        ) {
        
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) {
        FBSDKApplicationDelegate.sharedInstance()?.application(application,
                                                               didFinishLaunchingWithOptions: launchOptions)
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
        ) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance()?.application(app,
                                                                      open: url,
                                                                      options: options) ?? false
    }
}
