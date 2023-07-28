//
//  ConfirmViewController.swift
//  VK
//
//  Created by Эля Корельская on 23.07.2023.
//


import UIKit
import FirebaseAuth

class ConfirmViewController: UIViewController, UITextFieldDelegate {
    private let signInButton = AuthButton(type: .signUp, title: "ЗАРЕГИСТРИРОВАТЬСЯ")
    private let smsCodeField: AuthField = {
        let field = AuthField(type: .smsCode)
        return field
    }()
    var phoneNumber: String?
    private let confirmLabel: UILabel = {
        let label = UILabel()
        label.text = "Подтверждение регистрации"
        label.textColor = UIColor(named: "Orange")
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    private let detailsLabel1: UILabel = {
        let label = UILabel()
        label.text = "Мы отправили SMS с кодом на номер"
        label.textColor = UIColor(named: "Gray")
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    private let detailsLabel2: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "Gray")
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    private let detailsLabel3: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "Gray")
        label.textAlignment = .left
        label.text = "Введите код из SMS"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "checkmark")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsLabel2.text = phoneNumber ?? "Phone number not provided"
        view.backgroundColor = .white
        customizeBackButton()
        addSubview()
        configureFields()
        configureButtons()
    }
    
    func addSubview() {
        view.addSubview(signInButton)
        view.addSubview(confirmLabel)
        view.addSubview(detailsLabel1)
        view.addSubview(detailsLabel2)
        view.addSubview(iconImageView)
        view.addSubview(detailsLabel3)
        view.addSubview(smsCodeField)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        confirmLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel1.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel2.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel3.translatesAutoresizingMaskIntoConstraints = false
        smsCodeField.translatesAutoresizingMaskIntoConstraints = false
        
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            
            confirmLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 70),
            confirmLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 40),
            confirmLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -40),
            confirmLabel.heightAnchor.constraint(equalToConstant: 30),
            
            
            detailsLabel1.topAnchor.constraint(equalTo: confirmLabel.bottomAnchor, constant: 10),
            detailsLabel1.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 30),
            detailsLabel1.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -30),
            detailsLabel1.heightAnchor.constraint(equalToConstant: 30),
            
            
            detailsLabel2.topAnchor.constraint(equalTo: detailsLabel1.bottomAnchor),
            detailsLabel2.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 40),
            detailsLabel2.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -40),
            detailsLabel2.heightAnchor.constraint(equalToConstant: 40),
            
            
            detailsLabel3.topAnchor.constraint(equalTo: detailsLabel2.bottomAnchor, constant: 15),
            detailsLabel3.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 70),
            detailsLabel3.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -20),
            detailsLabel3.heightAnchor.constraint(equalToConstant: 30),
            
            
            signInButton.topAnchor.constraint(equalTo: detailsLabel3.bottomAnchor, constant: 140),
            signInButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 40),
            signInButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -40),
            signInButton.heightAnchor.constraint(equalToConstant: 55),
            
            
            iconImageView.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 80),
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 100),
            iconImageView.heightAnchor.constraint(equalToConstant: 100),
            
            
            smsCodeField.topAnchor.constraint(equalTo: detailsLabel3.bottomAnchor),
            smsCodeField.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 60),
            smsCodeField.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -60),
            smsCodeField.heightAnchor.constraint(equalToConstant: 50)
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
    
    func configureFields() {
        smsCodeField.delegate = self
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.width, height: 25))
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Закрыть", style: .done, target: self, action: #selector(didTapKeyboardDone))
        ]
        toolBar.sizeToFit()
        smsCodeField.inputAccessoryView = toolBar
    }
    
    @objc func didTapKeyboardDone() {
        smsCodeField.resignFirstResponder()
    }
    
    func configureButtons() {
        signInButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
    }
    
    @objc func didTapSignUp() {
        didTapKeyboardDone()

        if let code = smsCodeField.text, !code.isEmpty {
            AuthManager.shared.verifyCode(phoneNumber: phoneNumber ?? "user", smsCode: code) { [weak self] success, errorMessage in
                if success {
                    DispatchQueue.main.async { [self] in
                        HapticsManager.shared.vibrate(for: .success)
                        UserDefaults.standard.setValue(self?.phoneNumber, forKey: "phoneNumber")
                        self?.dismiss(animated: true, completion: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        HapticsManager.shared.vibrate(for: .error)
                        if let weakSelf = self {
                            if let errorMessage = errorMessage {
                                AlertManager.showAlert(on: weakSelf, with: "Sign In Failed", message: errorMessage)
                            } else {
                                AlertManager.showAlert(on: weakSelf, with: "Sign In Failed", message: "Unknown error occurred.")
                            }
                        }
                    }
                }
            }
        }
    }

}
