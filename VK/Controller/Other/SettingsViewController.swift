//
//  SettingsViewController.swift
//  VK
//
//  Created by Эля Корельская on 30.07.2023.
//

import UIKit

class SettingsViewController: UIViewController, UIViewControllerTransitioningDelegate {
    var user: User
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Settings"
        modalPresentationStyle = .custom
    }
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func presentHalfScreenController() {
        let halfScreenVC = HalfScreenPresentationController(presentedViewController: self, presenting: presentingViewController, user: user)
        halfScreenVC.halfScreenDelegate = self
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = halfScreenVC as? any UIViewControllerTransitioningDelegate
        presentingViewController?.present(self, animated: true, completion: nil)
    }
   

}
extension SettingsViewController: HalfScreenPresentationControllerDelegate {
    func didTapSettings() {
        let settingsVC = SettingsViewController(user: User(identifier: "", username: "", profilePictureURL: URL(string: ""), status: ""))
        let navigationController = UINavigationController(rootViewController: settingsVC)
        present(navigationController, animated: true, completion: nil)
    }
}
