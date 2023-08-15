//
//  NavigationRouter.swift
//  VK
//
//  Created by Эля Корельская on 14.08.2023.
//

import UIKit

class NavigationRouter {
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Properties
    let navigationController: UINavigationController
    var profileViewController: ProfileViewController?
    
    // MARK: - Interface
    func start() {
        let welcomeViewController = WelcomeViewController()
        welcomeViewController.delegateSignIn = self
        welcomeViewController.delegateSignUp = self
        welcomeViewController.delegateConfirm = self
        navigationController.pushViewController(welcomeViewController, animated: true)
    }
}

// MARK: - WelcomeViewControllerSignInDelegate
extension NavigationRouter: WelcomeViewControllerSignInDelegate {
    func welcomeViewControllerSignInTapped() {
        let signInViewController = SignInViewController()
        signInViewController.delegate = self
        
        navigationController.pushViewController(signInViewController, animated: true)
    }
}
// MARK: - WelcomeViewControllerSignUpDelegate
extension NavigationRouter: WelcomeViewControllerSignUpDelegate {
    func welcomeViewControllerSignUpTapped() {
        let signUpViewController = SignUpViewController()
        signUpViewController.delegate = self
        
        navigationController.pushViewController(signUpViewController, animated: true)
    }
}


// MARK: - SignUpViewControllerDelegate
extension NavigationRouter: SignUpViewControllerDelegate {
    func signUpViewControllerConfirmTappedWithPhoneNumber(_ phoneNumber: String) {
        let confirmationViewController = ConfirmViewController()
        confirmationViewController.phoneNumber = phoneNumber
        confirmationViewController.delegate = self
        
        navigationController.pushViewController(confirmationViewController, animated: true)
    }
}

// MARK: - ConfirmViewControllerDelegate
extension NavigationRouter: ConfirmViewControllerDelegate {
    func confirmViewControllerTabbarTapped() {
        let tabbarController = TabBarViewController()
        /// скрывает кнопку назад
        tabbarController.navigationItem.hidesBackButton = true
        navigationController.pushViewController(tabbarController, animated: true)
    }
}

// MARK: - ProfileViewControllerDelegate
extension NavigationRouter: ProfileViewControllerDelegate {
    func welcomeViewControllerSignOutTapped() {
        navigationController.popToRootViewController(animated: true)
    }
}

// MARK: - SignInViewControllerDelegate
extension NavigationRouter: SignInViewControllerDelegate {
    func signInViewControllerTabbarTapped() {
        let tabbarController = TabBarViewController()
        /// скрывает кнопку назад
        tabbarController.navigationItem.hidesBackButton = true
        navigationController.pushViewController(tabbarController, animated: true)
    }
}
