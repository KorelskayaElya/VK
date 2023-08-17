//
//  SignUpViewController.swift
//  VK
//
//  Created by Эля Корельская on 23.07.2023.
//

import Foundation
import UIKit
import KeychainAccess

protocol SignInViewControllerDelegate: AnyObject {
    func signInViewControllerTabbarTapped()
}

class SignInViewController: UIViewController, UITextFieldDelegate {
  
    // MARK: - UI
    /// кнопка подтвердить вход в аккаунт
    private let signInButton: AuthButton = {
        let button = AuthButton(type: .signIn, title: "Confirm".localized)
        return button
    }()
    /// кнопка поле ввода телефона
    private let phoneField: AuthField = {
        let field = AuthField(type: .phone)
        return field
    }()
    /// кнопка лейбл
    private let returnLabel: UILabel = {
        let label = UILabel()
        label.text = "You are welcome".localized
        label.textColor = UIColor(named: "Orange")
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    /// кнопка лейбл
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter you phone number".localized
        label.textColor = UIColor(named: "Gray")
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    // MARK: - Properties
    weak var delegate: SignInViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        configureConstraints()
        configureFields()
        customizeBackButton()
        configureButtons()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        phoneField.becomeFirstResponder()
    }
    
    // MARK: - Private
    private func addSubviews() {
        view.addSubview(signInButton)
        view.addSubview(phoneField)
        view.addSubview(returnLabel)
        view.addSubview(detailsLabel)
    }
    
    private func configureConstraints() {
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        phoneField.translatesAutoresizingMaskIntoConstraints = false
        returnLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            /// кнопка входа  в аккаунт
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -300),
            signInButton.heightAnchor.constraint(equalToConstant: 55),
            
            /// кнопка лейбл
            returnLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            returnLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            returnLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -200),
            returnLabel.heightAnchor.constraint(equalToConstant: 30),
            
            /// кнопка лейбл
            detailsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailsLabel.topAnchor.constraint(equalTo: returnLabel.bottomAnchor, constant: 10),
            detailsLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -200),
            detailsLabel.heightAnchor.constraint(equalToConstant: 50),
            
            /// поле ввода номера телефона
            phoneField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            phoneField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            phoneField.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 20),
            phoneField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    /// кнопка назад
    private func customizeBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "backarrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let customBackButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = customBackButton
    }
    /// навигация назад
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    /// клавиатура для ввода номера телефона
    private func configureFields() {
        phoneField.delegate = self
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.width, height: 25))
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Close".localized, style: .done, target: self, action: #selector(didTapKeyboardDone))
        ]
        toolBar.sizeToFit()
        phoneField.inputAccessoryView = toolBar
    }
    /// выход из клавиатуры по нажатию кнопки закрыть
    @objc private func didTapKeyboardDone() {
        phoneField.resignFirstResponder()
    }
    /// вход в аккаунт по нажатию кнопки подтвердить
    private func configureButtons() {
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    /// вход в аккаунт
    @objc private func didTapSignIn() {
        didTapKeyboardDone()
        if let phoneNumber = phoneField.text, !phoneNumber.isEmpty {
            AuthManager.shared.signIn(with: phoneNumber) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        HapticsManager.shared.vibrate(for: .success)
                        KeychainManager.shared.saveSignInFlag(true)
                        self?.delegate?.signInViewControllerTabbarTapped()
                    case .failure:
                        HapticsManager.shared.vibrate(for: .error)
                        let alert = UIAlertController(
                            title: "Error sign in".localized,
                            message: "Check you phone number and try again".localized, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
                        self?.present(alert, animated: true)
                        self?.phoneField.text = nil
                    }
                }
            }
        }
    }

}
