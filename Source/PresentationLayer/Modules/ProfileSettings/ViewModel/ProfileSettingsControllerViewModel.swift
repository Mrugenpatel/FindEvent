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
        var avatarImage: UIImage?
        var name: String
        var latitude: String
        var longitude: String
        var description: String
        
        init(avatarImage: UIImage?,
             name: String?,
             latitude: String?,
             longitude: String?,
             description: String?
            ) {
            self.avatarImage = avatarImage
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
    
    var userInfo = UserInfo(avatarImage: nil,
                            name: "",
                            latitude: "",
                            longitude: "",
                            description: "")
    
    
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
