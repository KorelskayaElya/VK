//
//  AppDelegate.swift
//  VK
//
//  Created by Эля Корельская on 22.07.2023.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        let welcomeVC = WelcomeViewController()
        let navVC = UINavigationController(rootViewController: welcomeVC)
        navVC.modalPresentationStyle = .fullScreen
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        
        return true
    }

    func switchToTabBarController() {
        let tabBarVC = TabBarViewController()
        tabBarVC.modalPresentationStyle = .fullScreen
        window?.rootViewController = tabBarVC
    }
}

