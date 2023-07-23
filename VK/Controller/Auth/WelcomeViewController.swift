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

    private let signInButton = AuthButton(type: .signIn, title: "ЗАРЕГИСТРИРОВАТЬСЯ")
    private let alreadySignUp = AuthButton(type: .alreadySignUp, title: "Уже есть аккаунт")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        configureButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let imageSize: CGFloat = 350
        welcomeImageView.frame = CGRect(x: (view.width - imageSize)/2, y: view.safeAreaInsets.top + 100, width: imageSize, height: imageSize)
        signInButton.frame = CGRect(x: 60, y: welcomeImageView.bottom+20, width: view.width-120, height: 55)
        alreadySignUp.frame = CGRect(x: 70, y: signInButton.bottom+20,width: view.width-150, height: 35 )

    }
    func addSubviews() {
        view.addSubview(welcomeImageView)
        view.addSubview(signInButton)
        view.addSubview(alreadySignUp)
    }
    func configureButtons() {
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        alreadySignUp.addTarget(self, action: #selector(didTapAlreadySignUp), for: .touchUpInside)
    }
    @objc func didTapSignIn() {
        let vc = SignInViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func didTapAlreadySignUp() {
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    

    
}
