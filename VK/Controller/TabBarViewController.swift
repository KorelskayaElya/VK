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
        customizeTabBarAppearance()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !signInPresented {
            presentSignIn()
        }
    }

    private func presentSignIn() {
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
    private func customizeTabBarAppearance() {
        let orangeColor = UIColor(named: "Orange")
        let selectedAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: orangeColor!]
        let normalAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.gray]

        UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes, for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes(normalAttributes, for: .normal)
        UITabBar.appearance().tintColor = orangeColor
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
        
        
        let tabBarItem1 = UITabBarItem(title: "Главная", image: UIImage(systemName: "house"), tag: 1)
        let tabBarItem2 = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.crop.circle"), tag: 2)
        let tabBarItem3 = UITabBarItem(title: "Сохраненные", image: UIImage(systemName: "heart"), tag: 3)

        tabBarItem1.selectedImage = UIImage(systemName: "house.fill")
        tabBarItem2.selectedImage = UIImage(systemName: "person.crop.circle.fill")
        tabBarItem3.selectedImage = UIImage(systemName: "heart.fill")

        nav1.tabBarItem = tabBarItem1
        nav2.tabBarItem = tabBarItem2
        nav3.tabBarItem = tabBarItem3
        
        setViewControllers([nav1,nav2,nav3], animated: false)
    }
}
