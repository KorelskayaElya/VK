//
//  SignInViewController.swift
//  VK
//
//  Created by Эля Корельская on 23.07.2023.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {
   
    private let nextButton = AuthButton(type: .signIn, title: "ДАЛЕЕ")
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
        addSubview()
        customizeBackButton()
        configureFields()
        configureButtons()
        
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
    func addSubview() {
        view.addSubview(signInLabel)
        view.addSubview(detailsLabel1)
        view.addSubview(detailsLabel2)
        view.addSubview(nextButton)
        view.addSubview(detailsLabel3)
        view.addSubview(phoneField)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInLabel.frame = CGRect(x: 40, y: view.top + 200, width: view.width - 80, height: 30)
        detailsLabel1.frame = CGRect(x: 35, y: signInLabel.bottom + 30, width: view.width - 80, height: 50)
        detailsLabel2.frame = CGRect(x: 70, y: detailsLabel1.bottom + 2, width: view.width - 140, height: 50)
        nextButton.frame = CGRect(x: 40, y: view.bottom-250, width: view.width-80, height: 55)
        detailsLabel3.frame = CGRect(x: 40, y: nextButton.bottom + 15, width: view.width - 80, height: 50)
        phoneField.frame = CGRect(x: 60, y: detailsLabel2.bottom + 20, width: view.width - 120, height: 50)
        
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
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapKeyboardDone))
        ]
        toolBar.sizeToFit()
        phoneField.inputAccessoryView = toolBar
    }
    @objc func didTapKeyboardDone() {
        phoneField.resignFirstResponder()
    }
    func configureButtons() {
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
    }
    @objc func didTapNext() {
        didTapKeyboardDone()
        let vc = ConfirmViewController()
        vc.phoneNumber = phoneField.text
        navigationController?.pushViewController(vc, animated: true)
    }
    
    

}
