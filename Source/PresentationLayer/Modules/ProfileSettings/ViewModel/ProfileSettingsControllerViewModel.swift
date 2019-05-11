//
//  ProfileSettingsViewModel.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 3/30/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Position

struct UserInfo {
    var avatarURL: String
    var avatarImage: UIImage?
    var name: String
    var coordinate: GeoPoint?
    var description: String

    init(avatarURL: String?,
         avatarImage: UIImage?,
         name: String?,
         coordinate: GeoPoint?,
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
        self.coordinate = coordinate
        if let description = description {
            self.description = description
        } else {
            self.description = ""
        }
    }
}

class ProfileSettingsControllerViewModel {

    // Properties

    var currentData: UserInfo

    var editedUserInfo: UserInfo!

    var updatedImage: UIImage?

    var dismissVC: EmptyClosure?

    private var userDefaultsService: UserDefaultsService
    private var userService: UserService
    private var imageService: ImageService
    private var emailAuthService: EmailAuthService
    private var facebookAuthService: FacebookAuthService
    
    lazy var sections = ProfileSettingsSection.allCases
    
    var numberOfSections: Int {
        return sections.count
    }
    
    init(
        userDefaultsService: UserDefaultsService,
        userService: UserService,
        imageService: ImageService,
        emailAuthService: EmailAuthService,
        facebookAuthService: FacebookAuthService,
        currentData: UserInfo
        ) {
        self.userDefaultsService = userDefaultsService
        self.userService = userService
        self.imageService = imageService
        self.emailAuthService = emailAuthService
        self.facebookAuthService = facebookAuthService
        self.currentData = currentData
        self.editedUserInfo = currentData
    }
    
    // MARK: Callbacks
    
    var didCatchError: ((String) -> (Void))?
    var isAnimating: ((Bool) -> (Void))?
    var startingLogout: EmptyClosure?
    
    // MARK: Methods

    func saveEditedInfo() {
        isAnimating?(true)

        guard editedUserInfo.name.count > 3 else {
            isAnimating?(false); didCatchError?("Too short name"); return
        }

        guard editedUserInfo.description.count < 30 else {
            isAnimating?(false); didCatchError?("Max 30 symbols for bio"); return
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
                                                                    coordinate: self?.editedUserInfo.coordinate,
                                                                    lastOnlineDate: true,
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
                                                            coordinate: self?.editedUserInfo.coordinate,
                                                            lastOnlineDate: true,
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

    func observeLocation(completion: @escaping (Bool) -> Void) {
        Position.shared.distanceFilter = 20

        if Position.shared.locationServicesStatus == .allowedWhenInUse ||
            Position.shared.locationServicesStatus == .allowedAlways {
            Position.shared.performOneShotLocationUpdate(withDesiredAccuracy: 250) { [weak self] location, error in
                guard
                    error == nil,
                    let location = location
                    else { return }
                self?.editedUserInfo.coordinate = GeoPoint(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude)
                completion(true)
            }
        } else {
            didCatchError?("Location Services disabled. Please enable Location Services in Settings and reload the Application")
        }
    }

    func shareCurrentLocation(isSharing: Bool) {
       userDefaultsService.shareCurrentLocation = isSharing
    }
}
