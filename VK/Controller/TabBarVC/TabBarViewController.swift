//
//  TabBarViewController.swift
//  VK
//
//  Created by Эля Корельская on 22.07.2023.
//

import UIKit
import KeychainAccess

class TabBarViewController: UITabBarController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpControllers()
        customizeTabBarAppearance()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// скрывает навигацию 
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Private
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
        let profile = ProfileViewController(user: User(identifier: "annaux_desinger", username: "Анна Мищенко", profilePicture: UIImage(named: "header1"), status: "дизайнер"))
        /// переход обратно на экран приветствия при выходе на экране профиля
        let scene = UIApplication.shared.connectedScenes.first
        if let sceneDelegate : SceneDelegate = (scene?.delegate as? SceneDelegate) {
            if let router = sceneDelegate.router {
                profile.delegate = router
            }
        }
        let saved = LikeViewController()
        
        saved.title = "Понравившиеся посты"

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

        setViewControllers([nav1, nav2, nav3], animated: false)
    }
}
