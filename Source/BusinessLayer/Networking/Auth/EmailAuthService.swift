//
//  EmailAuthService.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/6/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import FirebaseAuth

protocol EmailAuthServiceType: AuthServiceType {
    
    func signUp(
        withName name: String,
        withEmail email: String,
        withPassword password: String,
        withUserImg img: UIImage?,
        withLatitude latitude: String,
        withLongitude longtitude: String,
        completion: @escaping AuthResult
    )
    
    func signIn(
        withEmail email: String,
        withPassword password: String,
        completion: @escaping AuthResult
    )

    func forgotPassword(
        withEmail email: String,
        completion: @escaping (Result<Bool, AuthServiceError>) -> Void
    )
}

class EmailAuthService: EmailAuthServiceType {

    private let firebaseAuth = Auth.auth()
    
    private var currentFirebaseUser: FirebaseAuth.User? {
        return firebaseAuth.currentUser
    }
    
    var currentUserId: String? {
        guard let firUserId = currentFirebaseUser?.uid else { return nil }
        return firUserId
    }
    
    private let userService: UserService
    
    private let imageService: ImageService
    
    init(userService: UserService, imageService: ImageService) {
        self.userService = userService
        self.imageService = imageService
    }
    
    func signUp(
        withName name: String,
        withEmail email: String,
        withPassword password: String,
        withUserImg img: UIImage?,
        withLatitude latitude: String = "",
        withLongitude longitude: String = "",
        completion: @escaping AuthResult
        ) {
        firebaseAuth.createUser(
            withEmail: email,
            password: password)
        { [weak self] (responseData, responseError) in
            guard let strongSelf = self else { return }
            guard let firebaseError = responseError else {
                
                guard let user = responseData?.user else { completion(.failure(.userNotFound)); return }
                
                guard let currentUserId = strongSelf.currentUserId else { completion(.failure(.userNotFound)); return }
                
                if let image = img {
                    strongSelf.imageService.uploadImage(
                        image,
                        identifier: currentUserId)
                    { responsResult in
                        
                        switch responsResult {
                            
                        case .success(let url):
                            let stringURL = url.absoluteString
                            
                            strongSelf.userService.create(
                                user: User(
                                    id: user.uid,
                                    name: name,
                                    email: email,
                                    avatarImgURL: stringURL,
                                    latitude: latitude,
                                    longitude: longitude,
                                    isOnline: true,
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
                            id: user.uid,
                            name: name,
                            email: email,
                            avatarImgURL: "",
                            latitude: latitude,
                            longitude: longitude,
                            isOnline: true,
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
            completion(.failure(.getError(error: firebaseError))); return
        }
    }
    
    func signIn(
        withEmail email: String,
        withPassword password: String,
        completion: @escaping AuthResult
        ) {
        firebaseAuth.signIn(
            withEmail: email,
            password: password)
        { [weak self] (_, responseError) in
            
            guard let strongSelf = self else { return }
            
            guard let firebaseError = responseError else {
                
                guard let currentUserId = strongSelf.currentUserId else { completion(.failure(.userNotFound)); return }
                
                strongSelf.userService.getById(
                    userId: currentUserId)
                { responseResult in
                    switch responseResult {
                    case .success(let user):
                        completion(.success(user))
                    case .failure: completion(.failure(.failedToGetUser))
                    }
                }
                return
            }
            let error = AuthServiceError.getError(error: firebaseError)
            completion(.failure(error))
        }
    }
    
    func signOut(
        completion: @escaping (Result<Bool, AuthServiceError>) -> Void
        ) {
        do {
            try firebaseAuth.signOut()
            completion(.success(true))
        } catch let signOutError as NSError {
            completion(.failure(.getError(error: signOutError)))
        }
    }

    func forgotPassword(
        withEmail email: String,
        completion: @escaping (Result<Bool, AuthServiceError>) -> Void
        ) {
        firebaseAuth.sendPasswordReset(withEmail: email) { responseError in
            guard let firebaseError = responseError else { completion(.success(true)); return }
            completion(.failure(.getError(error: firebaseError)))

//            if error == nil && self.emailTextField.text?.isEmpty==false{
//                let resetEmailAlertSent = UIAlertController(title: "Reset Email Sent", message: "Reset email has been sent to your login email, please follow the instructions in the mail to reset your password", preferredStyle: .alert)
//            }

        }
    }
}
//
//    func updatePassword(newPassword: String,
//                        repeatNewPassword: String,
//                        completion: @escaping (Result<Bool, AuthServiceError>) -> Void) {
//        if newPassword.isEmpty, repeatNewPassword.isEmpty { completion(.failure(.emptyPassword)); return }
//        if newPassword == repeatNewPassword {
//            currentFirebaseUser?.updatePassword(to: newPassword, completion: { (error) in
//                if let error = error {
//                    completion(.failure(.getError(error: error)))
//                } else {
//                    completion(.success(true))
//                }
//            })
//        } else {completion(.failure(.failedToChangePassword))}
//    }

