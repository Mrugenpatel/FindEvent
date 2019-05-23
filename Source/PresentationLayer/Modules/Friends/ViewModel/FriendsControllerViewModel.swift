//
//  FriendsControllerViewModel.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation

final class FriendsControllerViewModel {
    
    // MARK: - Properties
    
    private var userService: UserService
    private var imageService: ImageService
    private var friendsService: FriendsService
    
    init(
        userService: UserService,
        imageService: ImageService,
        friendsService: FriendsService
        ) {
        self.userService = userService
        self.imageService = imageService
        self.friendsService = friendsService
    }
    
    // MARK: - Callbacks
    
    var didCatchError: ((String) -> (Void))?
    var isFriendsTableAnimating: ((Bool) -> (Void))?
    var isRequestsTableAnimating: ((Bool) -> (Void))?
    var isSentTableAnimating: ((Bool) -> (Void))?
    
    private var friends = [User]()
    private var sent = ([User],[FriendRequest]).self
    
    var numberOfFriends: Int {
        return friends.count
    }
    
    func fetchFriends() {
        isFriendsTableAnimating?(true)
        friendsService.getFriends { [weak self] responseResult in
            switch responseResult {
            case .success(let users):
                self?.isFriendsTableAnimating?(false)
                self?.friends = users
                print(users)
            case .failure(let error):
                print(error)
                self?.didCatchError?("Error")
            }
        }
    }
    
    func fetchSent() {
        
    }
    
    func fetchRequests() {
        
    }
    
    
}
