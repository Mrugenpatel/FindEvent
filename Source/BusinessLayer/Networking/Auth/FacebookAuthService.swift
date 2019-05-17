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
        ) { // if image(Optional) -> set imageUrl from Facebook
        
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

                /////
                let currentUserDocument = Firestore.firestore().collection("users").document(currentUserID) /// !
                currentUserDocument.getDocument(completion: { [weak self] (data,error) in
                    guard let strongSelf = self else {return}
                    if error == nil {
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
    
    
    //    fileprivate static func saveUserIntoFirebaseDatabase(profileImageData: Data, sparkUser: SparkUser?, completion: @escaping (_ message: String, _ error: Error?, _ sparkUser: SparkUser?) ->()) {
    //
    //        guard let sparkUser = sparkUser else { completion("Failed to fetch sparkUser", nil, nil); return }
    //
    //        fetchSparkUser(sparkUser.uid) { (message, err, fetchedSparkUser) in
    //            if let err = err {
    //                completion("Failed to fetch user data", err, nil)
    //                return
    //            }
    //
    //            guard let fetchedSparkUser = fetchedSparkUser else {
    //                saveSparkUser(profileImageData: profileImageData, sparkUser: sparkUser, completion: completion)
    //                return
    //            }
    //
    //            deleteAsset(fromUrl: fetchedSparkUser.profileImageUrl, completion: { (result, err) in
    //                if let err = err {
    //                    completion("Failed to deleted profile image form Storage", err, nil)
    //                    return
    //                }
    //
    //                if result {
    //
    //                    saveSparkUser(profileImageData: profileImageData, sparkUser: sparkUser, completion: completion)
    //
    //                } else {
    //                    completion("Failed to delete profile image from Storage", err, nil)
    //                }
    //            })
    //        }
    //
    //    }
    //
    //    fileprivate static func saveSparkUser(profileImageData: Data, sparkUser: SparkUser, completion: @escaping (_ message: String, _ error: Error?, _ sparkUser: SparkUser?) ->()) {
    //
    //        guard let profileImage = UIImage(data: profileImageData) else { completion("Failed to generate profile image from data", nil, nil); return }
    //        guard let profileImageUploadData = profileImage.jpegData(compressionQuality: 0.3) else { completion("Failed to compress jpeg data", nil, nil); return }
    //
    //        let fileName = UUID().uuidString
    //        Storage_Profile_Images.child(fileName).putData(profileImageUploadData, metadata: nil) { (metadata, err) in
    //            if let err = err { completion("Failed to save profile image to Storage with error:", err, nil); return }
    //            guard let metadata = metadata, let path = metadata.path else { completion("Failed to get metadata or path to profile image url.", nil, nil); return }
    //            Spark.getDownloadUrl(from: path, completion: { (profileImageFirebaseUrl, err) in
    //                if let err = err { completion("Failed to get download url with error:", err, nil); return }
    //                guard let profileImageFirebaseUrl = profileImageFirebaseUrl else { completion("Failed to get profileImageUrl.", nil, nil); return }
    //                print("Successfully uploaded profile image into Firebase storage with URL:", profileImageFirebaseUrl)
    //
    //                let documentPath = sparkUser.uid
    //                let documentData = [SparkKeys.SparkUser.uid: sparkUser.uid,
    //                                    SparkKeys.SparkUser.name: sparkUser.name,
    //                                    SparkKeys.SparkUser.email: sparkUser.email,
    //                                    SparkKeys.SparkUser.profileImageUrl: profileImageFirebaseUrl] as [String : Any]
    //
    //                Spark.Firestore_Users_Collection.document(documentPath).setData(documentData, completion: { (err) in
    //                    if let err = err { completion("Failed to save document with error:", err, nil); return }
    //                    let newSparkUser = SparkUser(documentData: documentData)
    //                    print("Successfully saved user info into Firestore: \(String(describing: newSparkUser))")
    //                    completion("Successfully signed in with Facebook.", nil, newSparkUser)
    //                })
    //
    //            })
    //        }
    //    }
    //
    //    // MARK: -
    //    // MARK: Fetch Profile Image
    //    static func fetchProfileImage(sparkUser: SparkUser, completion: @escaping (_ message: String, _ error: Error?, _ image: UIImage?) ->()) {
    //        let profileImageUrl = sparkUser.profileImageUrl
    //        guard let url = URL(string: profileImageUrl) else { completion("Failed to create url for profile image.", nil, nil); return }
    //
    //        URLSession.shared.dataTask(with: url) { (data, response, err) in
    //            if err != nil { completion("Failed to fetch profile image with url:", err, nil); return }
    //            guard let data = data else { completion("Failed to fetch profile image data", nil, nil); return }
    //            let profileImage = UIImage(data: data)
    //            completion("Successfully fetched profile image", nil, profileImage)
    //            }.resume()
    //    }
    //
    //    // MARK: -
    //    // MARK: Fetch Current Spark User
    //    static func fetchCurrentSparkUser(completion: @escaping (_ message: String, _ error: Error?, _ sparkUser: SparkUser?) ->()) {
    //        if Auth.auth().currentUser != nil {
    //            guard let uid = Auth.auth().currentUser?.uid else { completion("Failed to fetch user uid.", nil, nil); return }
    //            fetchSparkUser(uid, completion: completion)
    //        }
    //    }
    //
    //    // MARK: -
    //    // MARK: Fetch Spark User with uid
    //    static func fetchSparkUser(_ uid: String, completion: @escaping (_ message: String, _ error: Error?, _ sparkUser: SparkUser?) ->()) {
    //        Firestore_Users_Collection.whereField(SparkKeys.SparkUser.uid, isEqualTo: uid).getDocuments { (snapshot, err) in
    //            if let err = err { completion("Failed to fetch docuemnt with error:", err, nil); return }
    //            guard let snapshot = snapshot, let sparkUser = snapshot.documents.first.flatMap({SparkUser(documentData: $0.data())}) else { completion("Failed to get spark user from snapshot.", nil, nil); return }
    //            completion("Successfully fetched spark user", nil, sparkUser)
    //        }
    //    }
    //
    //    // MARK: -
    //    // MARK: Delete Asset
    //    static func deleteAsset(fromUrl url: String, completion: @escaping (_ result: Bool, _ error: Error?) ->()) {
    //        Storage.storage().reference(forURL: url).getMetadata { (metadata, err) in
    //            if let err = err, let errorCode = StorageErrorCode(rawValue: err._code) {
    //                if errorCode == .objectNotFound {
    //                    print("Asset not found, no need to delete")
    //                    completion(true, nil)
    //                    return
    //                }
    //            }
    //
    //            Storage.storage().reference(forURL: url).delete { (err) in
    //                if let err = err {
    //                    print("Could not delete asset at url:", url)
    //                    completion(false, err)
    //                    return
    //                }
    //                print("Successfully deleted asset from url:", url)
    //                completion(true, nil)
    //            }
    //
    //        }
    //
    //    }
    //
    //    // MARK: -
    //    // MARK: Get download URL
    //    static func getDownloadUrl(from path: String, completion: @escaping (String?, Error?) -> Void) {
    //        Storage.storage().reference().child(path).downloadURL { (url, err) in
    //            completion(url?.absoluteString, err)
    //        }
    //    }
}
