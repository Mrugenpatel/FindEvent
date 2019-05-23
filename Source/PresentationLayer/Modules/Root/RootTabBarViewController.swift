//
//  RootTabBarViewController.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/11/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

final class RootTabBarController: UITabBarController {
    private struct Constants {
        static let friends = NSLocalizedString("Friends", comment: "")
        static let friendsImg = UIImage(named: "friends.png")
        
        static let events = NSLocalizedString("Events", comment: "")
        static let eventsImg = UIImage(named: "events.png")
        
        static let chats = NSLocalizedString("Chats", comment: "")
        static let chatsImg = UIImage(named: "chats.png")
        
        static let game = NSLocalizedString("Games", comment: "")
        static let gameImg = UIImage(named: "games.png")
        
        static let settings = NSLocalizedString("Settings", comment: "")
        static let settingsImg = UIImage(named: "settings.png")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    weak var settingsViewController: SettingsViewController?
    
    var doneCallback:(() -> Void)? {
        didSet {
            settingsViewController?.doneCallback = doneCallback
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers(configureStackOfViewControllers(), animated: true)
        tabBar.barTintColor = ViewConfig.Colors.background
        tabBar.isTranslucent = false
    }
    
    private func configureStackOfViewControllers() -> [UIViewController]? {
        
        let friends = FriendsViewController(
            viewModel: FriendsControllerViewModel(
                userService: UserService(),
                imageService: ImageService(),
                friendsService: FriendsService(usersService: UserService())))
        let friendsVC = createRootNavigationViewController(
            withVC: friends,
            withTitle: Constants.friends)
        friendsVC.tabBarItem.title = Constants.friends
        friendsVC.tabBarItem.image = Constants.friendsImg
        
        let events = EventsViewController(
            viewModel: EventsControllerViewModel())
        let eventsVC = createRootNavigationViewController(
            withVC: events,
            withTitle: Constants.events)
        eventsVC.tabBarItem.title = Constants.events
        eventsVC.tabBarItem.image = Constants.eventsImg
        
        let chats = ChatsViewController(
            viewModel: ChatsControllerViewModel())
        let chatsVC = createRootNavigationViewController(
            withVC: chats,
            withTitle: Constants.chats)
        chatsVC.tabBarItem.title = Constants.chats
        chatsVC.tabBarItem.image = Constants.chatsImg
        
        let game = GameViewController(
            viewModel: GameControllerViewModel())
        let gameVC = createRootNavigationViewController(
            withVC: game,
            withTitle: Constants.game)
        gameVC.tabBarItem.title = Constants.game
        gameVC.tabBarItem.image = Constants.gameImg
        
        let settings = SettingsViewController(
            viewModel: SettingsControllerViewModel(userService: UserService(), imageService: ImageService()))
        settingsViewController = settings
        let settingsVC = createRootNavigationViewController(
            withVC: settings,
            withTitle: Constants.settings)
        settingsVC.tabBarItem.title = Constants.settings
        settingsVC.tabBarItem.image = Constants.settingsImg
        
        return [
            friendsVC,
            eventsVC,
            chatsVC,
            gameVC,
            settingsVC
        ]
    }
    
    private func createRootNavigationViewController(withVC viewController: UIViewController,
                                                    withTitle title: String) -> UINavigationController {
        let rootNavigationViewController = UINavigationController(rootViewController: viewController)
        rootNavigationViewController.navigationBar.isTranslucent = false
        rootNavigationViewController.isNavigationBarHidden = false
        rootNavigationViewController.navigationBar.barTintColor = ViewConfig.Colors.background
        rootNavigationViewController.navigationBar.topItem?.title = title
        return rootNavigationViewController
    }
}

