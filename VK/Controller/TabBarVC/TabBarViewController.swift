//
//  TabBarViewController.swift
//  VK
//
//  Created by Эля Корельская on 22.07.2023.
//

import UIKit
import KeychainAccess

class TabBarViewController: UITabBarController {


    override func viewDidLoad() {
        super.viewDidLoad()
        setUpControllers()
        customizeTabBarAppearance()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if KeychainManager.shared.getSignInFlag() == false {
//            presentWelcomeVC()
//        } else {
//            presentTabBarController()
//        }
    }

    private func presentWelcomeVC() {
        let welcomeVC = WelcomeViewController()
        welcomeVC.completion = { [weak self] in
            self?.presentTabBarController()
        }
        let navVC = UINavigationController(rootViewController: welcomeVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: false, completion: nil)
    }
    // как открыть tab bar чтобы он был на время главным контроллером
    // для tab bar нет completion
    // запускается криво
    private func presentTabBarController() {
        let tabbarVC = TabBarViewController()
        let navVC = UINavigationController(rootViewController: tabbarVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: false, completion: nil)
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
        var urlString: String?
        let home = HomeViewController()
        let profile = ProfileViewController(user: User(identifier: "annaux_desinger", username: "Анна Мищенко", profilePicture: UIImage(named: "header1"), status: "дизайнер"))
        let saved = LikeViewController()

        home.title = "Главная"
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
