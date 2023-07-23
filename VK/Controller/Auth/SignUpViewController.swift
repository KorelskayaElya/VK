//
//  SignUpViewController.swift
//  VK
//
//  Created by Эля Корельская on 23.07.2023.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    private let signUpButton = AuthButton(type: .signUp, title: "Подтвердить")
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
       // title = "Sign up"
        view.backgroundColor = .systemBackground
        addSubviews()
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signUpButton.frame = CGRect(x: 60, y: view.bottom-250, width: view.width-120, height: 55)
        returnLabel.frame = CGRect(x: 100, y: view.top + 300, width: view.width - 200, height: 30)
        detailsLabel.frame = CGRect(x: 100, y: returnLabel.bottom + 10, width: view.width - 200, height: 50)
        phoneField.frame = CGRect(x: 60, y: detailsLabel.bottom + 20, width: view.width - 120, height: 50)
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
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
    }
    @objc func didTapSignUp() {
        didTapKeyboardDone()
    }
    
}
