//
//  EmailAuthService.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/6/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import FirebaseAuth

class EmailAuthService {

}

enum AuthServiceError {
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

protocol AuthServiceType {
    typealias AuthHandler = (Result<User, AuthServiceError>) -> Void
    //TODO: Consider refactoring this method!!!
    func signInWith(
        email: String,
        password: String,
        completion: @escaping AuthHandler
    )
    //TODO: Consider refactoring this method!!!
    func signUp(
        withName name: String,
        withEmail email: String,
        withPassword password: String,
        withUserImg img: UIImage?,
        completion: @escaping AuthHandler)
    func signOut(
        completion: @escaping (Result<Bool, AuthServiceError>) -> Void)
    func updatePassword(newPassword: String,
                        repeatNewPassword: String,
                        completion: @escaping (Result<Bool, AuthServiceError>) -> Void)

    var currentUserId: String? { get }
}

class AuthService: AuthServiceType {

    private let firebaseAuth = Auth.auth()
    private let userService: UserServiceType
    private var currentFirebaseUser: FirebaseAuth.User? {
        return firebaseAuth.currentUser
    }

    var currentUserId: String? {
        guard let firUserId = currentFirebaseUser?.uid else { return nil }
        return firUserId
    }

    init(userService: UserServiceType) {
        self.userService = userService
    }

    func signInWith(
        email: String,
        password: String,
        completion: @escaping AuthHandler
        ) {
        firebaseAuth.signIn(withEmail: email, password: password) { [weak self] (_, authError) in
            guard let strongSelf = self else { return }
            guard let authError = authError else {
                guard let currentUserId = strongSelf.currentUserId else { return }
                strongSelf
                    .userService
                    .getById(currentUserId)
                    .subscribe(onNext: { userResult in
                        switch userResult {
                        case .success(let user): completion(.success(user))
                        case .failure: completion(.failure(.failedToGetUser))
                        }
                    }).disposed(by: strongSelf.disposeBag)
                return
            }
            let error = AuthServiceError.getError(error: authError)
            completion(.failure(error))
        }
    }

    func signUp(withName name: String,
                withEmail email: String,
                withPassword password: String,
                withUserImg img: UIImage?,
                completion: @escaping AuthHandler) {
        firebaseAuth.createUser(withEmail: email, password: password) { (authResult, authError) in
            guard let authError = authError else {
                guard let user = authResult?.user else { completion(.failure(.internalInconsistency)); return }
                self.updateUser(forUser: user, updateName: name, completion: { [unowned self] (result) in
                    switch result {
                    case .success:
                        guard let currentUserId = self.currentUserId else { completion(.failure(.userNotFound)); return }
                        self.userService.create(
                            User(id: currentUserId,
                                 name: name,
                                 email: email,
                                 avatarImgURL: ""
                            ), completion: { (result) in
                                switch result {
                                case .success(let user):
                                    completion(.success(user))
                                case .failure:
                                    completion(.failure(.failedToCreateUser))
                                }
                        })
                    case .failure(let error):
                        completion(.failure(error))
                    }
                })
                return
            }

            completion(.failure(.getError(error: authError)))
            return
        }
    }

    func signOut(
        completion: @escaping (Result<Bool, AuthServiceError>) -> Void) {
        do {
            try firebaseAuth.signOut()
            completion(.success(true))
        } catch let signOutError as NSError {
            completion(.failure(.getError(error: signOutError)))
        }
    }

    func updatePassword(newPassword: String,
                        repeatNewPassword: String,
                        completion: @escaping (Result<Bool, AuthServiceError>) -> Void) {
        if newPassword.isEmpty, repeatNewPassword.isEmpty { completion(.failure(.emptyPassword)); return }
        if newPassword == repeatNewPassword {
            currentFirebaseUser?.updatePassword(to: newPassword, completion: { (error) in
                if let error = error {
                    completion(.failure(.getError(error: error)))
                } else {
                    completion(.success(true))
                }
            })
        } else {completion(.failure(.failedToChangePassword))}
    }

    private func updateUser(forUser user: FirebaseAuth.User,
                            updateName name: String,
                            completion: @escaping (Result<Bool, AuthServiceError>) -> Void) {
        let updatableUser = user.createProfileChangeRequest()
        updatableUser.displayName = name
        updatableUser.commitChanges { responseError in
            guard let error = responseError else { completion(.success(true)); return }
            completion(.failure(.getError(error: error)))
        }
    }
}

// MARK: change place!
class User {
    private enum Constants: String {
        case id
        case name
        case email
        case avatarImgURL
    }

    let id: String?
    var name: String?
    let email: String?
    var avatarImgURL: String?

    init?(user: [String: Any]) {
        guard let id = user[Constants.id.rawValue] as? String else { return nil }
        self.id = id
        guard let name = user[Constants.name.rawValue] as? String else { return nil }
        self.name = name
        guard let email = user[Constants.email.rawValue] as? String else { return nil }
        self.email = email
        guard let avatarImgURL = user[Constants.avatarImgURL.rawValue] as? String else { return nil }
        self.avatarImgURL = avatarImgURL
    }

    init(id: String,
         name: String,
         email: String,
         avatarImgURL: String) {

        self.id = id
        self.name = name
        self.email = email
        self.avatarImgURL = avatarImgURL

    }

    func data() -> [String: Any] {
        return [Constants.id.rawValue: id as Any,
                Constants.name.rawValue: name as Any,
                Constants.email.rawValue: email as Any,
                Constants.avatarImgURL.rawValue: avatarImgURL as Any]
}

