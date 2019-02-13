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

        static let chats = NSLocalizedString("Chat", comment: "")
        static let chatsImg = UIImage(named: "chat.png")

        static let game = NSLocalizedString("Game", comment: "")
        static let gameImg = UIImage(named: "game.png")

        static let settings = NSLocalizedString("Settings", comment: "")
        static let settingsImg = UIImage(named: "settings.png")
    }

    weak var settingsViewController: SettingsViewController?

    var doneCallback:(() -> Void)? {
        didSet {
            settingsViewController?.rootView.doneCallback = doneCallback
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
            viewModel: FriendsControllerViewModel())
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

        


//
//        let calendarVC = createRootNavigationViewController(
//            withVC: CalendarViewController(),
//            withTitle: Constants.calendar)
//        calendarVC.tabBarItem.title = Constants.calendar
//        calendarVC.tabBarItem.image = UIImage(named: "calendar.png")
//
//        let locationVC = LocationViewController(
//            nibName: "LocationViewController",
//            bundle: nil)
//        locationVC.tabBarItem.title = Constants.map
//        locationVC.tabBarItem.image = Constants.mapImg
//
//        let chatsVC = createRootNavigationViewController(
//            withVC: ChatsViewController(viewModel: ),
//            withTitle: Constants.chats)
//        chatsVC.tabBarItem.title = Constants.chats
//        chatsVC.tabBarItem.image = Constants.chatsImg
//
//        let more =
//            SettingsViewController(viewModel: )
//        settingsViewController = setings
//        let moreVC = createRootNavigationViewController(
//            withVC: more,
//            withTitle: Constants.more)
//        moreVC.tabBarItem.title = Constants.more
//        moreVC.tabBarItem.image = Constants.moreImg
          return [friendsVC, eventsVC]
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

