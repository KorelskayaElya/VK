//
//  SignUpViewController.swift
//  VK
//
//  Created by Эля Корельская on 23.07.2023.
//

import Foundation
import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {
    private let signUpButton: AuthButton = {
        let button = AuthButton(type: .signIn, title: "Подтвердить")
        button.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        return button
    }()
    
    private let phoneField: AuthField = {
        let field = AuthField(type: .phone)
        return field
    }()
    
    private let returnLabel: UILabel = {
        let label = UILabel()
        label.text = "С возвращением"
        label.textColor = UIColor(named: "Orange")
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите номер телефона для входа в приложение"
        label.textColor = UIColor(named: "Gray")
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        configureConstraints()
        configureFields()
        configureButtons()
        customizeBackButton()
    }
    
    func addSubviews() {
        view.addSubview(signUpButton)
        view.addSubview(phoneField)
        view.addSubview(returnLabel)
        view.addSubview(detailsLabel)
    }
    
    func configureConstraints() {
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        phoneField.translatesAutoresizingMaskIntoConstraints = false
        returnLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Sign Up Button constraints
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -300),
            signUpButton.heightAnchor.constraint(equalToConstant: 55),
            
            // Return Label constraints
            returnLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            returnLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            returnLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -200),
            returnLabel.heightAnchor.constraint(equalToConstant: 30),
            
            // Details Label constraints
            detailsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailsLabel.topAnchor.constraint(equalTo: returnLabel.bottomAnchor, constant: 10),
            detailsLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -200),
            detailsLabel.heightAnchor.constraint(equalToConstant: 50),
            
            // Phone Field constraints
            phoneField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            phoneField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            phoneField.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 20),
            phoneField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        phoneField.becomeFirstResponder()
    }
    
    func customizeBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "backarrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let customBackButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = customBackButton
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func configureFields() {
        phoneField.delegate = self
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.width, height: 25))
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapKeyboardDone))
        ]
        toolBar.sizeToFit()
        phoneField.inputAccessoryView = toolBar
    }
    
    @objc func didTapKeyboardDone() {
        phoneField.resignFirstResponder()
    }
    
    func configureButtons() {
        signUpButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    @objc func didTapSignIn() {
        didTapKeyboardDone()
        if let phoneNumber = phoneField.text, !phoneNumber.isEmpty {
            DatabaseManager.shared.getPhone(for: phoneNumber) { existingPhoneNumber in
                if existingPhoneNumber != nil {
                    // +16505551234
                    print(existingPhoneNumber)
                    // не понимаю как сравнить все зарегистрированные номера
                    if existingPhoneNumber == phoneNumber {
                        // User is already signed in, show the success alert
                        DispatchQueue.main.async {
                            UserDefaults.standard.setValue(phoneNumber, forKey: "phoneNumber")
                            let alert = UIAlertController(
                                title: "Вход",
                                message: "Заходим в аккаунт.",
                                preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: { _ in
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true)
                        }
                    } else {
                        DispatchQueue.main.async {
                            HapticsManager.shared.vibrate(for: .error)
                            let alert = UIAlertController(
                                title: "Ошибка авторизации",
                                message: "Пользователь с указанным номером телефона не зарегистрирован.",
                                preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: nil))
                            self.present(alert, animated: true)
                        }
                    }
                }
            }
        }
        
    }
}
