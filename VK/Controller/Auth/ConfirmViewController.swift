//
//  ConfirmViewController.swift
//  VK
//
//  Created by Эля Корельская on 23.07.2023.
//

import UIKit

class ConfirmViewController: UIViewController, UITextFieldDelegate {
    private let signInButton = AuthButton(type: .signIn, title: "ЗАРЕГИСТРИРОВАТЬСЯ")
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
        label.font = .systemFont(ofSize: 17, weight: .regular)
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
        label.textAlignment = .center
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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        confirmLabel.frame = CGRect(x: 40, y: view.top + 200, width: view.width - 80, height: 30)
        detailsLabel1.frame = CGRect(x: 40, y: confirmLabel.bottom + 30, width: view.width - 80, height: 20)
        detailsLabel2.frame = CGRect(x: 40, y: detailsLabel1.bottom, width: view.width - 80, height: 40)
        detailsLabel3.frame = CGRect(x: 20, y: detailsLabel2.bottom + 15, width: view.width - 200, height: 50)
        signInButton.frame = CGRect(x: 40, y: detailsLabel3.bottom + 110, width: view.width-80, height: 55)
        iconImageView.frame = CGRect(x: 150, y: view.bottom - 220, width: 100, height: 100)
        smsCodeField.frame = CGRect(x: 60, y: detailsLabel3.bottom, width: view.width - 120, height: 50)
        
    }
    func configureFields() {
        smsCodeField.delegate = self

        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.width, height: 25))
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapKeyboardDone))
        ]
        toolBar.sizeToFit()
        smsCodeField.inputAccessoryView = toolBar
    }
    @objc func didTapKeyboardDone() {
        smsCodeField.resignFirstResponder()
    }
    func configureButtons() {
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    @objc func didTapSignIn() {
        didTapKeyboardDone()
    }

  

}
