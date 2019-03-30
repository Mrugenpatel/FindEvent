//
//  AppDelegate.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/4/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

let App = UIApplication.shared.delegate as! Application

@UIApplicationMain
class Application: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootViewController: RootViewController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        viewSetup()
        UserService.setUserStatus(isOnline: true)
        return true
    }

    private func viewSetup() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = ViewConfig.Colors.background

        UINavigationBar.appearance().tintColor = ViewConfig.Colors.textWhite
        UINavigationBar.appearance().barTintColor = ViewConfig.Colors.background
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key(
            rawValue: NSAttributedString.Key.foregroundColor.rawValue): ViewConfig.Colors.white]

        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: ViewConfig.Colors.textWhite], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: ViewConfig.Colors.blue], for: .selected)

        rootViewController = RootViewController(userDefaultsService: UserDefaultsService())

        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()

        SVProgressHUD.setMinimumDismissTimeInterval(1)
        SVProgressHUD.setDefaultMaskType(.gradient)
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        UserService.setUserStatus(isOnline: false)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UserService.setUserStatus(isOnline: true)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        UserService.setUserStatus(isOnline: false)
    }
}

