//
//  ConfirmViewController.swift
//  VK
//
//  Created by Эля Корельская on 23.07.2023.
//


import UIKit
import FirebaseAuth

protocol ConfirmViewControllerDelegate: AnyObject {
    func confirmViewControllerTabbarTapped()
}

class ConfirmViewController: UIViewController, UITextFieldDelegate {
    // MARK: - UI
    private let confirmBtn = AuthButton(type: .signUp, title: "Sign Up".localized)
    
    private let smsCodeField: AuthField = {
        let field = AuthField(type: .smsCode)
        return field
    }()
    
    private let confirmLabel: UILabel = {
        let label = UILabel()
        label.text = "Confirm sign up".localized
        label.textColor = UIColor(named: "Orange")
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let detailsLabel1: UILabel = {
        let label = UILabel()
        label.text = "We sent you an SMS with a code".localized
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
        label.text = "Enter an SMS code".localized
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
    
    // MARK: - Properties
    var phoneNumber: String?
    
    weak var delegate: ConfirmViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsLabel2.text = phoneNumber ?? "Phone number not provided"
        view.backgroundColor = .systemBackground
        customizeBackButton()
        addSubview()
        configureFields()
        configureButtons()
    }
    
    func addSubview() {
        view.addSubview(confirmBtn)
        view.addSubview(confirmLabel)
        view.addSubview(detailsLabel1)
        view.addSubview(detailsLabel2)
        view.addSubview(iconImageView)
        view.addSubview(detailsLabel3)
        view.addSubview(smsCodeField)
        confirmBtn.translatesAutoresizingMaskIntoConstraints = false
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
            
            
            confirmBtn.topAnchor.constraint(equalTo: detailsLabel3.bottomAnchor, constant: 140),
            confirmBtn.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 40),
            confirmBtn.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -40),
            confirmBtn.heightAnchor.constraint(equalToConstant: 55),
            
            
            iconImageView.topAnchor.constraint(equalTo: confirmBtn.bottomAnchor, constant: 80),
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 100),
            iconImageView.heightAnchor.constraint(equalToConstant: 100),
            
            
            smsCodeField.topAnchor.constraint(equalTo: detailsLabel3.bottomAnchor),
            smsCodeField.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 60),
            smsCodeField.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -60),
            smsCodeField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    // MARK: - Private
    /// кнопка назад
    private func customizeBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "backarrow"), for: .normal)
        backButton.tintColor = UIColor(named: "Black")
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
    }
    /// навигация назад
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func configureFields() {
        smsCodeField.delegate = self
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.width, height: 25))
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Close".localized, style: .done, target: self, action: #selector(didTapKeyboardDone))
        ]
        toolBar.sizeToFit()
        smsCodeField.inputAccessoryView = toolBar
    }
    
    @objc private func didTapKeyboardDone() {
        smsCodeField.resignFirstResponder()
    }
    
    private func configureButtons() {
        confirmBtn.addTarget(self, action: #selector(didTapConfirm), for: .touchUpInside)
    }
    
    /// подтверждение входа в tabbarcontroller
    @objc private func didTapConfirm() {
        didTapKeyboardDone()

        if let code = smsCodeField.text, !code.isEmpty {
            AuthManager.shared.verifyCode(phoneNumber: phoneNumber ?? "user", smsCode: code) { [weak self] success, errorMessage in
                if success {
                    DispatchQueue.main.async { [self] in
                        HapticsManager.shared.vibrate(for: .success)
                        KeychainManager.shared.saveSignInFlag(true)
                        UserDefaults.standard.setValue(self?.phoneNumber, forKey: "phoneNumber")
                        
                        self?.delegate?.confirmViewControllerTabbarTapped()
                    }
                } else {
                    DispatchQueue.main.async {
                        HapticsManager.shared.vibrate(for: .error)
                        if let weakSelf = self {
                            if let errorMessage = errorMessage {
                                AlertManager.showAlert(on: weakSelf, with: "Authentication Failed".localized, message: errorMessage)
                            } else {
                                AlertManager.showAlert(on: weakSelf, with: "Authentication Failed".localized, message: "Unknown error occurred".localized)
                            }
                        }
                    }
                }
            }
        }
    }
}
