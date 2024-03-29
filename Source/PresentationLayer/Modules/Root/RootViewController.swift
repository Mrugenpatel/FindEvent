//
//  RootViewController.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/11/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

final class RootViewController: UIViewController {
    private var userDefaultsService: UserDefaultsService!
    private var currentViewController: UIViewController?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    convenience init(userDefaultsService: UserDefaultsService) {
        self.init()
        self.userDefaultsService = userDefaultsService
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        decideWhatToShow()
    }
    
    private func decideWhatToShow() {
        if !userDefaultsService.isUserLogin {
            
            let welcome = createRootNavigationViewController(
                with: WelcomeViewController(viewModel: WelcomeControllerViewModel()))
            
            currentViewController = welcome
            
            let welcomeViewController = welcome.children.first as? WelcomeViewController
            welcomeViewController?.doneCallback = { [unowned self] in
                self.userDefaultsService.isUserLogin = true
                self.clear(asChild: self.currentViewController)
                self.decideWhatToShow()
            }
            
        } else if userDefaultsService.isUserLogin {
            
            let tabBar = RootTabBarController()
            tabBar.doneCallback = { [unowned self] in
                self.userDefaultsService.isUserLogin = false
                self.clear(asChild: self.currentViewController)
                self.decideWhatToShow()
            }
            
            currentViewController = tabBar
            
        }
        
        guard let currentViewController = self.currentViewController else { return }
        add(asChild: currentViewController)
    }
    
    private func add<T: UIViewController>(asChild viewController: T) {
        self.addChild(viewController)
        self.view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    private func clear(asChild viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
        currentViewController = nil
    }
    
    private func createRootNavigationViewController(with viewController: UIViewController) -> UINavigationController {
        return UINavigationController(rootViewController: viewController)
    }
}
