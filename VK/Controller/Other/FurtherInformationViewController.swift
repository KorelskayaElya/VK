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
    private lazy var usernameLabel = LabelField()
    private lazy var usernameLabel1 = LabelField()
    private lazy var statusLabel = LabelField()
    private lazy var statusLabel1 = LabelField()
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
    private lazy var universityLabel = LabelField()
    private lazy var universityLabel1 = LabelField()
    private lazy var workLabel = LabelField()
    private lazy var workLabel1 = LabelField()
    
    // MARK: -  Properties
    var receivedUsername: String = ""
    var receivedGender: String = ""
    var receivedBirthday: String = ""
    var receivedCity: String = ""
    var receivedHobby: String = ""
    var receivedSchool: String = ""
    var receivedUniversity: String = ""
    var receivedWork: String = ""
    var receivedStatus: String = ""
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "backarrow"), for: .normal)
        backButton.tintColor = UIColor(named: "Orange")
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        view.backgroundColor = .systemBackground
        title = "Подробная информация".localized
        setupView()
        constraints()
    }
    
    // MARK: - Private
    private func setupView() {
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel1.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel1.font = UIFont.boldSystemFont(ofSize: 15)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel1.translatesAutoresizingMaskIntoConstraints = false
        statusLabel1.font = UIFont.boldSystemFont(ofSize: 15)
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
        universityLabel.translatesAutoresizingMaskIntoConstraints = false
        universityLabel1.translatesAutoresizingMaskIntoConstraints = false
        universityLabel1.font = UIFont.boldSystemFont(ofSize: 15)
        workLabel.translatesAutoresizingMaskIntoConstraints = false
        workLabel1.translatesAutoresizingMaskIntoConstraints = false
        workLabel1.font = UIFont.boldSystemFont(ofSize: 15)
        usernameLabel1.text = "Имя Фамилия".localized
        genderLabel1.text = "Пол".localized
        birthdayLabel1.text = "Дата рождения".localized
        cityLabel1.text = "Родной город".localized
        hobbyLabel1.text = "Интересы".localized
        schoolLabel1.text = "Школа".localized
        universityLabel1.text = "Университет".localized
        workLabel1.text = "Место работы".localized
        statusLabel1.text = "Статус".localized
        usernameLabel.text = receivedUsername
        statusLabel.text = receivedStatus
        genderLabel.text = receivedGender
        birthdayLabel.text = receivedBirthday
        cityLabel.text = receivedCity
        schoolLabel.text = receivedSchool
        universityLabel.text = receivedUniversity
        hobbyLabel.text = receivedHobby
        view.addSubview(usernameLabel)
        view.addSubview(genderLabel)
        view.addSubview(birthdayLabel)
        view.addSubview(cityLabel)
        view.addSubview(hobbyLabel)
        view.addSubview(schoolLabel)
        view.addSubview(universityLabel)
        view.addSubview(workLabel)
        view.addSubview(usernameLabel1)
        view.addSubview(genderLabel1)
        view.addSubview(birthdayLabel1)
        view.addSubview(cityLabel1)
        view.addSubview(hobbyLabel1)
        view.addSubview(schoolLabel1)
        view.addSubview(universityLabel1)
        view.addSubview(workLabel1)
        view.addSubview(statusLabel)
        view.addSubview(statusLabel1)
    }
    private func constraints() {
        NSLayoutConstraint.activate([
            usernameLabel1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            usernameLabel1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameLabel1.widthAnchor.constraint(equalToConstant: 300),
            usernameLabel1.heightAnchor.constraint(equalToConstant: 20),
            
            usernameLabel.topAnchor.constraint(equalTo: usernameLabel1.bottomAnchor, constant: 5),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameLabel.widthAnchor.constraint(equalToConstant: 300),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            statusLabel1.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 20),
            statusLabel1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel1.widthAnchor.constraint(equalToConstant: 300),
            statusLabel1.heightAnchor.constraint(equalToConstant: 20),
            
            statusLabel.topAnchor.constraint(equalTo: statusLabel1.bottomAnchor, constant: 5),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.widthAnchor.constraint(equalToConstant: 300),
            statusLabel.heightAnchor.constraint(equalToConstant: 20),
            
            genderLabel1.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 20),
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
            
            universityLabel1.topAnchor.constraint(equalTo: schoolLabel.bottomAnchor, constant: 20),
            universityLabel1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            universityLabel1.widthAnchor.constraint(equalToConstant: 300),
            universityLabel1.heightAnchor.constraint(equalToConstant: 20),
            
            universityLabel.topAnchor.constraint(equalTo: universityLabel1.bottomAnchor, constant: 5),
            universityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            universityLabel.widthAnchor.constraint(equalToConstant: 300),
            universityLabel.heightAnchor.constraint(equalToConstant: 20),
            
            workLabel1.topAnchor.constraint(equalTo: universityLabel.bottomAnchor, constant: 20),
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
