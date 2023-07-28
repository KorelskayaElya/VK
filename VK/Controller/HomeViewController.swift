//
//  ViewController.swift
//  VK
//
//  Created by Эля Корельская on 22.07.2023.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(buttonOut)
        constraints()
    }
    private var buttonOut: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.octagon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didOut), for: .touchUpInside)
        return button
    }()
    // временная кнопка для выхода из аккаунта
    @objc func didOut() {
        let actionSheet = UIAlertController(title: "Sign Out",
                                            message: "Would you like to sign out?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { [weak self] _ in
            DispatchQueue.main.async {
                AuthManager.shared.signOut { success in
                    if success {
                        UserDefaults.standard.setValue(nil, forKey: "phone")

                        let vc = WelcomeViewController()
                        let navVC = UINavigationController(rootViewController: vc)
                        navVC.modalPresentationStyle = .fullScreen
                        self?.present(navVC,
                                      animated: true,
                                      completion: nil)

                        self?.navigationController?.popToRootViewController(animated: true)
                        self?.tabBarController?.selectedIndex = 0
                    } else {
                        // failed
                        let alert = UIAlertController(title: "Woops",
                                                      message: "Something went wrong when signing out. Please try again.",
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                        self?.present(alert, animated: true)
                    }
                }
            }
        }))
        present(actionSheet, animated: true)
    }
    func constraints() {
        NSLayoutConstraint.activate([
            buttonOut.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonOut.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonOut.widthAnchor.constraint(equalToConstant: 100),
            buttonOut.heightAnchor.constraint(equalToConstant: 100),
        ])
    }

}

