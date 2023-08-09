//
//  SceneDelegate.swift
//  VK
//
//  Created by Эля Корельская on 22.07.2023.
//

import UIKit
import KeychainAccess

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        
        if KeychainManager.shared.getSignInFlag() == true {
            let tabBarVC = TabBarViewController()
            window.rootViewController = tabBarVC
        } else {
            let welcomeVC = WelcomeViewController()
            welcomeVC.completion = { [weak self] in
                self?.presentTabBarController()
            }
            let navVC = UINavigationController(rootViewController: welcomeVC)
            navVC.modalPresentationStyle = .fullScreen
            window.rootViewController = navVC
        }
        
        self.window = window
        window.makeKeyAndVisible()
    }

    private func presentTabBarController() {
        let tabBarVC = TabBarViewController()
        tabBarVC.modalPresentationStyle = .fullScreen
        window?.rootViewController?.present(tabBarVC, animated: true, completion: nil)
    }
}
