//
//  SignInViewController.swift
//  VK
//
//  Created by Эля Корельская on 23.07.2023.
//

import Foundation
import UIKit

class WelcomeViewController: UIViewController {

    public var completion: (() -> Void)?

    private let welcomeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "SignIn")
        return imageView
    }()

    private let signInButton: AuthButton = {
        let button = AuthButton(type: .signUp, title: "ЗАРЕГИСТРИРОВАТЬСЯ")
        button.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        return button
    }()

    private let alreadySignUp: AuthButton = {
        let button = AuthButton(type: .alreadySignUp, title: "Уже есть аккаунт")
        button.addTarget(self, action: #selector(didTapAlreadySignUp), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        configureConstraints()
    }

    func addSubviews() {
        view.addSubview(welcomeImageView)
        view.addSubview(signInButton)
        view.addSubview(alreadySignUp)
    }

    func configureConstraints() {
        welcomeImageView.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        alreadySignUp.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            welcomeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            welcomeImageView.widthAnchor.constraint(equalToConstant: 350),
            welcomeImageView.heightAnchor.constraint(equalToConstant: 350),


            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            signInButton.topAnchor.constraint(equalTo: welcomeImageView.bottomAnchor, constant: 20),
            signInButton.heightAnchor.constraint(equalToConstant: 55),

            alreadySignUp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            alreadySignUp.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
            alreadySignUp.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20),
            alreadySignUp.heightAnchor.constraint(equalToConstant: 35)
        ])
    }

    @objc func didTapSignUp() {
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func didTapAlreadySignUp() {
        let vc = SignInViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
