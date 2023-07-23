//
//  TabBarViewController.swift
//  VK
//
//  Created by Эля Корельская on 22.07.2023.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    private var signInPresented = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpControllers()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !signInPresented {
            presentSignInIfNeeded()
        }
    }

    private func presentSignInIfNeeded() {
        if !AuthManager.shared.isSignedIn {
            signInPresented = true
            let vc = WelcomeViewController()
            vc.completion = { [weak self] in
                self?.signInPresented = false
            }
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            present(navVC, animated: false, completion: nil)
        }
    }
    private func setUpControllers() {
        let home = HomeViewController()
        let profile = ProfileViewController()
        let saved = SavedViewController()
        
        home.title = "Home"
        profile.title = "Profile"
        saved.title = "Saved"
        
        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: profile)
        let nav3 = UINavigationController(rootViewController: saved)
        
        
        nav1.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.circle"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Сохраненные", image: UIImage(systemName: "heart"), tag: 3)
        
        setViewControllers([nav1,nav2,nav3], animated: false)
    }
}
