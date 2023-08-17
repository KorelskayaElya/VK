//
//  SignInViewController.swift
//  VK
//
//  Created by Эля Корельская on 23.07.2023.
//

import Foundation
import UIKit

protocol WelcomeViewControllerSignUpDelegate: AnyObject {
    func welcomeViewControllerSignUpTapped()
}
protocol WelcomeViewControllerSignInDelegate: AnyObject {
    func welcomeViewControllerSignInTapped()
}

class WelcomeViewController: UIViewController {
    
    // MARK: - UI
    /// изображение логотип
    private let welcomeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "SignIn")
        return imageView
    }()
    /// кнопка регистрации
    private let signUpButton: AuthButton = {
        let button = AuthButton(type: .signUp, title: "ЗАРЕГИСТРИРОВАТЬСЯ".localized)
        button.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        return button
    }()
    /// кнопка есть аккаунт
    private let alreadySignUp: AuthButton = {
        let button = AuthButton(type: .alreadySignUp, title: "Уже есть аккаунт".localized)
        button.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    weak var delegateSignIn: WelcomeViewControllerSignInDelegate?
    weak var delegateSignUp: WelcomeViewControllerSignUpDelegate?
    weak var delegateConfirm: ConfirmViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
        }
        addSubviews()
        configureConstraints()
        checksignInFlag()
    }
    
    // MARK: - Private
    private func addSubviews() {
        view.addSubview(welcomeImageView)
        view.addSubview(signUpButton)
        view.addSubview(alreadySignUp)
    }

    private func configureConstraints() {
        welcomeImageView.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        alreadySignUp.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            welcomeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            welcomeImageView.widthAnchor.constraint(equalToConstant: 350),
            welcomeImageView.heightAnchor.constraint(equalToConstant: 350),


            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            signUpButton.topAnchor.constraint(equalTo: welcomeImageView.bottomAnchor, constant: 20),
            signUpButton.heightAnchor.constraint(equalToConstant: 55),

            alreadySignUp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            alreadySignUp.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
            alreadySignUp.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 20),
            alreadySignUp.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    /// переход на экран регистрации
    @objc private func didTapSignUp() {
        delegateSignUp?.welcomeViewControllerSignUpTapped()
    }
    /// переход на экран входа в профиль при наличии аккаунта
    @objc private func didTapSignIn() {
        delegateSignIn?.welcomeViewControllerSignInTapped()
    }
}
extension WelcomeViewController {
    /// проаерка флага входа
    func checksignInFlag() {
        guard let signInFlag = KeychainManager.shared.getSignInFlag(), signInFlag else {return}
        delegateConfirm?.confirmViewControllerTabbarTapped()
    }
}
