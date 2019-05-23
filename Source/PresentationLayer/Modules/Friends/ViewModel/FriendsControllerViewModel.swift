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
    
    private var friendUsers = [User]()
    private var sentUsers = [User]()
    private var sentRequests = [FriendRequest]()
    private var requestUsers = [User]()
    private var requestRequests = [FriendRequest]()
    
    var numberOfFriends: Int {
        return friendUsers.count
    }
    
    func fetchFriends() {
        isFriendsTableAnimating?(true)
        friendsService.getFriends { [weak self] responseResult in
            switch responseResult {
            case .success(let users):
                self?.isFriendsTableAnimating?(false)
                self?.friendUsers = users
                print(users)
            case .failure(let error):
                print(error)
                self?.isFriendsTableAnimating?(false)
                self?.didCatchError?("Error")
            }
        }
    }
    
    func fetchSent() {
        isSentTableAnimating?(true)
        friendsService.getSent { [weak self] responseResult in
            switch responseResult {
                
            case .success(let users, let sentRequests):
                self?.sentUsers = users
                self?.sentRequests = sentRequests
            case .failure(let error):
                print(error)
                self?.isSentTableAnimating?(false)
                self?.didCatchError?("Error")
            }
        }
    }
    
    func fetchRequests() {
        isRequestsTableAnimating?(true)
        friendsService.getSent { [weak self] responseResult in
            switch responseResult {
                
            case .success(let users, let requestRequests):
                self?.requestUsers = users
                self?.requestRequests = requestRequests
            case .failure(let error):
                print(error)
                self?.isRequestsTableAnimating?(false)
                self?.didCatchError?("Error")
            }
        }
    }
}
