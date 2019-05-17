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
import IQKeyboardManager
import Position
import FBSDKCoreKit

let App = UIApplication.shared.delegate as! Application

@UIApplicationMain
class Application: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootViewController: RootViewController!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
        firebaseSetup()
        locationSetup()
        keyboardSetup()
        viewSetup()
        UserService.setUserStatus(isOnline: true)
        return true
    }

    // MARK: - App Life Cycle

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

// MARK: - Setup

private extension Application {

    func viewSetup() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = ViewConfig.Colors.background

        rootViewController = RootViewController(userDefaultsService: UserDefaultsService())

        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()

        // - UINavigationBar Setup

        UINavigationBar.appearance().tintColor = ViewConfig.Colors.textWhite
        UINavigationBar.appearance().barTintColor = ViewConfig.Colors.background
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key(
            rawValue: NSAttributedString.Key.foregroundColor.rawValue): ViewConfig.Colors.white]

        // - UITabBarItem Setup

        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: ViewConfig.Colors.textWhite], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: ViewConfig.Colors.blue], for: .selected)

        // - SVProgressHUD Setup

        SVProgressHUD.setMinimumDismissTimeInterval(0.5)
        SVProgressHUD.setDefaultMaskType(.gradient)
    }

    func firebaseSetup() {
        FirebaseApp.configure()
    }

    func keyboardSetup() {
        let keyboardManager = IQKeyboardManager.shared()
        keyboardManager.isEnabled = true
    }

    func locationSetup() {
        let userDefaultsService = UserDefaultsService()
        if userDefaultsService.shareCurrentLocation {
            guard let currentUserId = Auth.auth().currentUser else { return }
            Position.shared.distanceFilter = 20
            if Position.shared.locationServicesStatus == .allowedWhenInUse ||
                Position.shared.locationServicesStatus == .allowedAlways {
                Position.shared.performOneShotLocationUpdate(withDesiredAccuracy: 250) { location, error in
                    guard
                        error == nil,
                        let location = location
                        else { return }
                    let coordinate = GeoPoint(
                        latitude: location.coordinate.latitude,
                        longitude: location.coordinate.longitude)
                    let userCollection = Firestore.firestore().collection("users")
                    userCollection.document(currentUserId.uid).setData(["coordinate": coordinate], merge: true)
                }
            }
        }
    }
}

