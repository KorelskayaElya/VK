//
//  InformationViewController.swift
//  VK
//
//  Created by Эля Корельская on 14.08.2023.
//

import UIKit

class InformationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Основная информация"
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        backButton.tintColor = UIColor(named: "Orange")
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        let doneBtn = UIButton(type: .system)
        doneBtn.setImage(UIImage(systemName: "checkmark"), for: .normal)
        doneBtn.tintColor = UIColor(named: "Orange")
        doneBtn.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneBtn)
        setupView()
        constraints()
        
    }
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc func nextButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    private lazy var nameLabel = LabelField()
    private lazy var surnameLabel = LabelField()
    private lazy var genderLabel = LabelField()
    private lazy var maleLabel = LabelField()
    private lazy var femaleLabel = LabelField()
    private lazy var birthdayLabel = LabelField()
    private lazy var cityLabel = LabelField()
    private lazy var dotmale = RoundButtonWithDot()
    private lazy var dotfemale = RoundButtonWithDot()
    private lazy var nameField: UITextField = {
        let field = UITextField()
        field.placeholder = "имя"
        field.tintColor = .lightGray
        field.delegate = self
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 20))
        field.leftView = paddingView
        field.leftViewMode = .always
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.cornerRadius = 15
        field.layer.borderWidth = 2
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    private lazy var surnameField: UITextField = {
        let field = UITextField()
        field.placeholder = "фамилия"
        field.tintColor = .lightGray
        field.delegate = self
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 20))
        field.leftView = paddingView
        field.leftViewMode = .always
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.cornerRadius = 15
        field.layer.borderWidth = 2
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    private lazy var birhdayField: UITextField = {
        let field = UITextField()
        field.placeholder = "01.01.2020"
        field.tintColor = .lightGray
        field.delegate = self
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 20))
        field.leftView = paddingView
        field.leftViewMode = .always
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.cornerRadius = 15
        field.layer.borderWidth = 2
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    private lazy var cityField: UITextField = {
        let field = UITextField()
        field.placeholder = "Напишите название"
        field.tintColor = .lightGray
        field.delegate = self
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 20))
        field.leftView = paddingView
        field.leftViewMode = .always
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.cornerRadius = 15
        field.layer.borderWidth = 2
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    
    private func setupView() {
        nameLabel.text = "Имя"
        surnameLabel.text = "Фамилия"
        genderLabel.text = "Пол"
        maleLabel.text = "Мужской"
        femaleLabel.text = "Женский"
        birthdayLabel.text = "Дата рождения"
        cityLabel.text = "Родной город"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        surnameLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        maleLabel.translatesAutoresizingMaskIntoConstraints = false
        femaleLabel.translatesAutoresizingMaskIntoConstraints = false
        birthdayLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        dotmale.translatesAutoresizingMaskIntoConstraints = false
        dotfemale.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        view.addSubview(surnameLabel)
        view.addSubview(genderLabel)
        view.addSubview(maleLabel)
        view.addSubview(femaleLabel)
        view.addSubview(birthdayLabel)
        view.addSubview(cityLabel)
        view.addSubview(nameField)
        view.addSubview(surnameField)
        view.addSubview(birhdayField)
        view.addSubview(cityField)
        view.addSubview(dotmale)
        view.addSubview(dotfemale)
        dotmale.addTarget(self, action: #selector(dotMaleButtonTapped), for: .touchUpInside)
        dotfemale.addTarget(self, action: #selector(dotFemaleButtonTapped), for: .touchUpInside)
    }

    private func constraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.widthAnchor.constraint(equalToConstant: 100),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            nameField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            nameField.heightAnchor.constraint(equalToConstant: 30),
            
            
            surnameLabel.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 30),
            surnameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            surnameLabel.widthAnchor.constraint(equalToConstant: 100),
            surnameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            surnameField.topAnchor.constraint(equalTo: surnameLabel.bottomAnchor, constant: 5),
            surnameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            surnameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            surnameField.heightAnchor.constraint(equalToConstant: 30),
            
            
            genderLabel.topAnchor.constraint(equalTo: surnameField.bottomAnchor, constant: 30),
            genderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            genderLabel.widthAnchor.constraint(equalToConstant: 100),
            genderLabel.heightAnchor.constraint(equalToConstant: 20),
            
            dotmale.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 25),
            dotmale.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dotmale.widthAnchor.constraint(equalToConstant: 25),
            dotmale.heightAnchor.constraint(equalToConstant: 25),
            
            dotfemale.topAnchor.constraint(equalTo: dotmale.bottomAnchor, constant: 5),
            dotfemale.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dotfemale.widthAnchor.constraint(equalToConstant: 25),
            dotfemale.heightAnchor.constraint(equalToConstant: 25),
            
            maleLabel.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 27),
            maleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:50),
            maleLabel.widthAnchor.constraint(equalToConstant: 100),
            maleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            femaleLabel.topAnchor.constraint(equalTo: maleLabel.bottomAnchor, constant: 10),
            femaleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:50),
            femaleLabel.widthAnchor.constraint(equalToConstant: 200),
            femaleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            birthdayLabel.topAnchor.constraint(equalTo: femaleLabel.bottomAnchor, constant: 30),
            birthdayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            birthdayLabel.widthAnchor.constraint(equalToConstant: 200),
            birthdayLabel.heightAnchor.constraint(equalToConstant: 20),
            
            birhdayField.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: 5),
            birhdayField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            birhdayField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            birhdayField.heightAnchor.constraint(equalToConstant: 30),
            
            cityLabel.topAnchor.constraint(equalTo: birhdayField.bottomAnchor, constant: 30),
            cityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cityLabel.widthAnchor.constraint(equalToConstant: 200),
            cityLabel.heightAnchor.constraint(equalToConstant: 20),
            
            cityField.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 5),
            cityField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            cityField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            cityField.heightAnchor.constraint(equalToConstant: 30),
        
        
    ])
    }
    @objc private func dotMaleButtonTapped() {
        dotmale.showDot()
        dotfemale.hideDot()
    }

    @objc private func dotFemaleButtonTapped() {
        dotmale.hideDot()
        dotfemale.showDot()
    }
}
extension InformationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 20
    }
}

