//
//  ProfileSettingsViewModel.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 3/30/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation
import FirebaseAuth

class ProfileSettingsControllerViewModel {
    
    struct UserInfo {
        var avatarURL: String
        var avatarImage: UIImage?
        var name: String
        var latitude: String
        var longitude: String
        var description: String

        init(avatarURL: String?,
             avatarImage: UIImage?,
             name: String?,
             latitude: String?,
             longitude: String?,
             description: String?
            ) {
            self.avatarImage = avatarImage
            if let avatarURL = avatarURL {
                self.avatarURL = avatarURL
            } else {
                self.avatarURL = ""
            }
            if let name = name {
                self.name = name
            } else {
                self.name = ""
            }
            if let latitude = latitude {
                self.latitude = latitude
            } else {
                self.latitude = ""
            }
            if let longitude = longitude {
                self.longitude = longitude
            } else {
                self.longitude = ""
            }
            if let description = description {
                self.description = description
            } else {
                self.description = ""
            }
        }
    }

    var editedUserInfo = UserInfo(avatarURL: "",
                                  avatarImage: nil,
                                  name: "",
                                  latitude: "",
                                  longitude: "",
                                  description: "")

    var updatedImage: UIImage?

    var dismissVC: EmptyClosure?

    private var userService: UserService
    private var imageService: ImageService
    private var emailAuthService: EmailAuthService
    private var facebookAuthService: FacebookAuthService
    
    lazy var sections = ProfileSettingsSection.allCases
    
    var numberOfSections: Int {
        return sections.count
    }
    
    init(
        userService: UserService,
        imageService: ImageService,
        emailAuthService: EmailAuthService,
        facebookAuthService: FacebookAuthService
        ) {
        self.userService = userService
        self.imageService = imageService
        self.emailAuthService = emailAuthService
        self.facebookAuthService = facebookAuthService
    }
    
    // MARK: Callbacks
    
    var didCatchError: ((String) -> (Void))?
    var isAnimating: ((Bool) -> (Void))?
    var startingLogout: EmptyClosure?
    
    // MARK: Methods
    
    func getUserInfo(completion: @escaping (UserInfo?) -> Void) {
        isAnimating?(true)
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            isAnimating?(false);
            didCatchError?("Network Error. Reload the App");
            return completion(nil)
        }
        userService.getById(
            userId: currentUserId
            )
        { [weak self] responseResult in
            guard let strongSelf = self else {return}
            switch responseResult {
                
            case .success(let user):
                self?.imageService.getImage(
                    by: user.avatarImgURL)
                { responseResult in
                    switch responseResult {
                        
                    case .success(let image):
                        strongSelf.isAnimating?(false)
                        completion(UserInfo(
                            avatarURL: user.avatarImgURL,
                            avatarImage: image,
                            name: user.name,
                            latitude: user.latitude,
                            longitude: user.longitude,
                            description: user.description
                            )
                        )
                    case .failure(_):
                        strongSelf.isAnimating?(false)
                        completion(UserInfo(
                            avatarURL: user.avatarImgURL,
                            avatarImage: nil,
                            name: user.name,
                            latitude: user.latitude,
                            longitude: user.longitude,
                            description: user.description
                            )
                        )
                    }
                }
            case .failure(_):
                strongSelf.isAnimating?(false)
                completion(nil)
                strongSelf.didCatchError?("Network Error. Reload the App")
            }
        }
    }

    func saveEditedInfo() {
        isAnimating?(true)

        guard editedUserInfo.name.count > 3 else {
            isAnimating?(false); didCatchError?("Too short name"); return
        }

        guard editedUserInfo.description.count > 10 && editedUserInfo.description.count < 30 else {
            isAnimating?(false); didCatchError?("Min 10 && Max 30 symbols for bio"); return
        }

        guard let currentUserId = Auth.auth().currentUser?.uid else {
            isAnimating?(false); didCatchError?("Network Error. Reload the App"); return
        }

        userService.getById(userId: currentUserId) { [weak self] responseResult in
            switch responseResult {
            case .success(let user):
                if let updatedImage = self?.updatedImage {
                    self?.imageService.uploadImage(updatedImage, identifier: currentUserId, completion: { [weak self] imageServiceResult in
                        switch imageServiceResult {
                        case .success(let updatedAvatarImageUrl):
                            self?.userService.updateById(user: User(id: user.id,
                                                                    name: self?.editedUserInfo.name,
                                                                    email: user.email,
                                                                    avatarImgURL: updatedAvatarImageUrl.absoluteString,
                                                                    latitude: self?.editedUserInfo.latitude,
                                                                    longitude: self?.editedUserInfo.longitude,
                                                                    isOnline: true,
                                                                    description: self?.editedUserInfo.description),
                                                         completion: { [weak self] responseResult in
                                                            switch responseResult {

                                                            case .success(_):
                                                                self?.isAnimating?(false)
                                                                self?.dismissVC?()
                                                            case .failure(_):
                                                                self?.didCatchError?("Failed to update Info. Retry please")
                                                                self?.isAnimating?(false); return
                                                            }
                            })
                        case .failure(_):
                            self?.didCatchError?("Image Uploading Failed")
                            self?.isAnimating?(false); return
                        }
                    })

                } else {
                    self?.userService.updateById(user: User(id: user.id,
                                                            name: self?.editedUserInfo.name,
                                                            email: user.email,
                                                            avatarImgURL: user.avatarImgURL,
                                                            latitude: self?.editedUserInfo.latitude,
                                                            longitude: self?.editedUserInfo.longitude,
                                                            isOnline: true,
                                                            description: self?.editedUserInfo.description),
                                                 completion: { [weak self] responseResult in
                                                    switch responseResult {

                                                    case .success(_):
                                                        self?.isAnimating?(false)
                                                        self?.dismissVC?()
                                                    case .failure(_):
                                                        self?.didCatchError?("Failed to update Info. Retry please")
                                                        self?.isAnimating?(false); return
                                                    }
                    })

                }
            case .failure(_):
                self?.didCatchError?("Network Error. Reload the App"); self?.isAnimating?(false); return
            }
        }


    }

    func logout() {
        emailAuthService.signOut { [weak self] responseResult in
            switch responseResult {
            case .success(let isSuccessful):
                isSuccessful ? self?.startingLogout?() : self?.didCatchError?("Log Out Failed. Reload the app or try one more")
            case .failure(let error):
                self?.didCatchError?(error.localizedDescription)
            }
        }
    }
}
