//
//  FurtherInformationViewController.swift
//  VK
//
//  Created by Эля Корельская on 14.08.2023.
//

import UIKit
// подробная информация
class FurtherInformationViewController: UIViewController {

    // MARK: - UI
    private lazy var nameLabel = LabelField()
    private lazy var nameLabel1 = LabelField()
    private lazy var surnameLabel = LabelField()
    private lazy var surnameLabel1 = LabelField()
    private lazy var genderLabel = LabelField()
    private lazy var genderLabel1 = LabelField()
    private lazy var birthdayLabel = LabelField()
    private lazy var birthdayLabel1 = LabelField()
    private lazy var cityLabel = LabelField()
    private lazy var cityLabel1 = LabelField()
    private lazy var hobbyLabel = LabelField()
    private lazy var hobbyLabel1 = LabelField()
    private lazy var schoolLabel = LabelField()
    private lazy var schoolLabel1 = LabelField()
    private lazy var univercityLabel = LabelField()
    private lazy var univercityLabel1 = LabelField()
    private lazy var workLabel = LabelField()
    private lazy var workLabel1 = LabelField()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "backarrow"), for: .normal)
        backButton.tintColor = UIColor(named: "Orange")
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        view.backgroundColor = .systemBackground
        navigationItem.title = "Подробная информация"
        setupView()
        constraints()
    }
    
    // MARK: - Private
    private func setupView() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel1.translatesAutoresizingMaskIntoConstraints = false
        nameLabel1.font = UIFont.boldSystemFont(ofSize: 15)
        surnameLabel.translatesAutoresizingMaskIntoConstraints = false
        surnameLabel1.translatesAutoresizingMaskIntoConstraints = false
        surnameLabel1.font = UIFont.boldSystemFont(ofSize: 15)
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel1.translatesAutoresizingMaskIntoConstraints = false
        genderLabel1.font = UIFont.boldSystemFont(ofSize: 15)
        birthdayLabel.translatesAutoresizingMaskIntoConstraints = false
        birthdayLabel1.translatesAutoresizingMaskIntoConstraints = false
        birthdayLabel1.font = UIFont.boldSystemFont(ofSize: 15)
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel1.translatesAutoresizingMaskIntoConstraints = false
        cityLabel1.font = UIFont.boldSystemFont(ofSize: 15)
        hobbyLabel.translatesAutoresizingMaskIntoConstraints = false
        hobbyLabel1.translatesAutoresizingMaskIntoConstraints = false
        hobbyLabel1.font = UIFont.boldSystemFont(ofSize: 15)
        schoolLabel.translatesAutoresizingMaskIntoConstraints = false
        schoolLabel1.translatesAutoresizingMaskIntoConstraints = false
        schoolLabel1.font = UIFont.boldSystemFont(ofSize: 15)
        univercityLabel.translatesAutoresizingMaskIntoConstraints = false
        univercityLabel1.translatesAutoresizingMaskIntoConstraints = false
        univercityLabel1.font = UIFont.boldSystemFont(ofSize: 15)
        workLabel.translatesAutoresizingMaskIntoConstraints = false
        workLabel1.translatesAutoresizingMaskIntoConstraints = false
        workLabel1.font = UIFont.boldSystemFont(ofSize: 15)
        nameLabel.text = "Анна"
        nameLabel1.text = "Имя"
        surnameLabel.text = "Мищенко"
        surnameLabel1.text = "Фамилия"
        genderLabel.text = "Женский"
        genderLabel1.text = "Пол"
        birthdayLabel.text = "01.01.1993"
        birthdayLabel1.text = "Дата рождения"
        cityLabel.text = "Москва"
        cityLabel1.text = "Родной город"
        hobbyLabel.text = "балет"
        hobbyLabel1.text = "Интересы"
        schoolLabel.text = "Школа 123"
        schoolLabel1.text = "Школа"
        univercityLabel.text = "Московский государственный"
        univercityLabel1.text = "Университет"
        workLabel.text = "Балерина"
        workLabel1.text = "Место работы"
        view.addSubview(nameLabel)
        view.addSubview(surnameLabel)
        view.addSubview(genderLabel)
        view.addSubview(birthdayLabel)
        view.addSubview(cityLabel)
        view.addSubview(hobbyLabel)
        view.addSubview(schoolLabel)
        view.addSubview(univercityLabel)
        view.addSubview(workLabel)
        view.addSubview(nameLabel1)
        view.addSubview(surnameLabel1)
        view.addSubview(genderLabel1)
        view.addSubview(birthdayLabel1)
        view.addSubview(cityLabel1)
        view.addSubview(hobbyLabel1)
        view.addSubview(schoolLabel1)
        view.addSubview(univercityLabel1)
        view.addSubview(workLabel1)
    }
    private func constraints() {
        NSLayoutConstraint.activate([
            nameLabel1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            nameLabel1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel1.widthAnchor.constraint(equalToConstant: 300),
            nameLabel1.heightAnchor.constraint(equalToConstant: 20),
            
            nameLabel.topAnchor.constraint(equalTo: nameLabel1.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.widthAnchor.constraint(equalToConstant: 300),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            surnameLabel1.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            surnameLabel1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            surnameLabel1.widthAnchor.constraint(equalToConstant: 300),
            surnameLabel1.heightAnchor.constraint(equalToConstant: 20),
            
            surnameLabel.topAnchor.constraint(equalTo: surnameLabel1.bottomAnchor, constant: 5),
            surnameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            surnameLabel.widthAnchor.constraint(equalToConstant: 300),
            surnameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            genderLabel1.topAnchor.constraint(equalTo: surnameLabel.bottomAnchor, constant: 20),
            genderLabel1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            genderLabel1.widthAnchor.constraint(equalToConstant: 300),
            genderLabel1.heightAnchor.constraint(equalToConstant: 20),
            
            genderLabel.topAnchor.constraint(equalTo: genderLabel1.bottomAnchor, constant: 5),
            genderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            genderLabel.widthAnchor.constraint(equalToConstant: 300),
            genderLabel.heightAnchor.constraint(equalToConstant: 20),
            
            birthdayLabel1.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 20),
            birthdayLabel1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            birthdayLabel1.widthAnchor.constraint(equalToConstant: 300),
            birthdayLabel1.heightAnchor.constraint(equalToConstant: 20),
            
            birthdayLabel.topAnchor.constraint(equalTo: birthdayLabel1.bottomAnchor, constant: 5),
            birthdayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            birthdayLabel.widthAnchor.constraint(equalToConstant: 300),
            birthdayLabel.heightAnchor.constraint(equalToConstant: 20),
            
            cityLabel1.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: 20),
            cityLabel1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cityLabel1.widthAnchor.constraint(equalToConstant: 300),
            cityLabel1.heightAnchor.constraint(equalToConstant: 20),
            
            cityLabel.topAnchor.constraint(equalTo: cityLabel1.bottomAnchor, constant: 5),
            cityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cityLabel.widthAnchor.constraint(equalToConstant: 300),
            cityLabel.heightAnchor.constraint(equalToConstant: 20),
            
            hobbyLabel1.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 20),
            hobbyLabel1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            hobbyLabel1.widthAnchor.constraint(equalToConstant: 300),
            hobbyLabel1.heightAnchor.constraint(equalToConstant: 20),
            
            hobbyLabel.topAnchor.constraint(equalTo: hobbyLabel1.bottomAnchor, constant: 5),
            hobbyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            hobbyLabel.widthAnchor.constraint(equalToConstant: 300),
            hobbyLabel.heightAnchor.constraint(equalToConstant: 20),
            
            schoolLabel1.topAnchor.constraint(equalTo: hobbyLabel.bottomAnchor, constant: 20),
            schoolLabel1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            schoolLabel1.widthAnchor.constraint(equalToConstant: 300),
            schoolLabel1.heightAnchor.constraint(equalToConstant: 20),
            
            schoolLabel.topAnchor.constraint(equalTo: schoolLabel1.bottomAnchor, constant: 5),
            schoolLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            schoolLabel.widthAnchor.constraint(equalToConstant: 300),
            schoolLabel.heightAnchor.constraint(equalToConstant: 20),
            
            univercityLabel1.topAnchor.constraint(equalTo: schoolLabel.bottomAnchor, constant: 20),
            univercityLabel1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            univercityLabel1.widthAnchor.constraint(equalToConstant: 300),
            univercityLabel1.heightAnchor.constraint(equalToConstant: 20),
            
            univercityLabel.topAnchor.constraint(equalTo: univercityLabel1.bottomAnchor, constant: 5),
            univercityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            univercityLabel.widthAnchor.constraint(equalToConstant: 300),
            univercityLabel.heightAnchor.constraint(equalToConstant: 20),
            
            workLabel1.topAnchor.constraint(equalTo: univercityLabel.bottomAnchor, constant: 20),
            workLabel1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            workLabel1.widthAnchor.constraint(equalToConstant: 300),
            workLabel1.heightAnchor.constraint(equalToConstant: 20),
            
            workLabel.topAnchor.constraint(equalTo: workLabel1.bottomAnchor, constant: 5),
            workLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            workLabel.widthAnchor.constraint(equalToConstant: 300),
            workLabel.heightAnchor.constraint(equalToConstant: 20),
            
            
            
        ])
    }
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
