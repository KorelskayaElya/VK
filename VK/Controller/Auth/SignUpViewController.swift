//
//  SignInViewController.swift
//  VK
//
//  Created by Эля Корельская on 23.07.2023.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    private let nextButton: AuthButton = {
        let button = AuthButton(type: .signUp, title: "ДАЛЕЕ")
        button.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        return button
    }()

    private let phoneField: AuthField = {
        let field = AuthField(type: .phone)
        return field
    }()

    private let signInLabel: UILabel = {
        let label = UILabel()
        label.text = "ЗАРЕГИСТРИРОВАТЬСЯ"
        label.textColor = UIColor(named: "Black")
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()

    private let detailsLabel1: UILabel = {
        let label = UILabel()
        label.text = "Введите номер"
        label.textColor = .systemGray2
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()

    private let detailsLabel2: UILabel = {
        let label = UILabel()
        label.text = "Ваш номер будет использоваться для входа в аккаунт"
        label.textColor = UIColor(named: "Gray")
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    private let detailsLabel3: UILabel = {
        let label = UILabel()
        label.text = "Нажимая кнопку 'Далее' Вы принимаете пользовательское Соглашение и политику конфиденциальности"
        label.textColor = UIColor(named: "Gray")
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // title = "Sign in"
        view.backgroundColor = .systemBackground
        addSubviews()
        customizeBackButton()
        configureFields()
        configureLayout()
    }

    func addSubviews() {
        view.addSubview(signInLabel)
        view.addSubview(detailsLabel1)
        view.addSubview(detailsLabel2)
        view.addSubview(nextButton)
        view.addSubview(detailsLabel3)
        view.addSubview(phoneField)
    }

    func configureLayout() {
        let margins = view.layoutMarginsGuide

        signInLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel1.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel2.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel3.translatesAutoresizingMaskIntoConstraints = false
        phoneField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            signInLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 70),
            signInLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 40),
            signInLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -40),
            signInLabel.heightAnchor.constraint(equalToConstant: 30),

            detailsLabel1.topAnchor.constraint(equalTo: signInLabel.bottomAnchor, constant: 30),
            detailsLabel1.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 35),
            detailsLabel1.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -35),
            detailsLabel1.heightAnchor.constraint(equalToConstant: 50),

            detailsLabel2.topAnchor.constraint(equalTo: detailsLabel1.bottomAnchor, constant: 2),
            detailsLabel2.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 60),
            detailsLabel2.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -60),
            detailsLabel2.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),

            nextButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -300),
            nextButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 40),
            nextButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -40),
            nextButton.heightAnchor.constraint(equalToConstant: 55),

            detailsLabel3.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 15),
            detailsLabel3.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 40),
            detailsLabel3.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -40),
            detailsLabel3.heightAnchor.constraint(equalToConstant: 50),

            phoneField.topAnchor.constraint(equalTo: detailsLabel2.bottomAnchor, constant: 20),
            phoneField.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 60),
            phoneField.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -60),
            phoneField.heightAnchor.constraint(equalToConstant: 50)
        ])
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        phoneField.becomeFirstResponder()
    }
    func configureFields() {
        phoneField.delegate = self

        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.width, height: 25))
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Закрыть", style: .done, target: self, action: #selector(didTapKeyboardDone))
        ]
        toolBar.sizeToFit()
        phoneField.inputAccessoryView = toolBar
    }
    @objc func didTapKeyboardDone() {
        phoneField.resignFirstResponder()
    }
    
    // переход на капчу и последующий ввод кода
    @objc func didTapNext() {
        didTapKeyboardDone()
        if let phone = phoneField.text, !phone.isEmpty {
            AuthManager.shared.startAuth(phoneNumber: phone) { [weak self] success, errorMessage in
                if success {
                    DispatchQueue.main.async {
                        let vc = ConfirmViewController()
                        vc.phoneNumber = phone
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        if let errorMessage = errorMessage, errorMessage.contains("already in use") {
                            if let weakSelf = self {
                                AlertManager.showAlert(on: weakSelf, with: "Authentication Failed", message: "Phone number is already registered. Please sign in instead.")
                            }
                        } else {
                            if let weakSelf = self {
                                AlertManager.showAlert(on: weakSelf, with: "Authentication Failed", message: errorMessage ?? "Unknown error occurred.")
                            }
                        }
                    }
                }
            }
        }
    }

}
