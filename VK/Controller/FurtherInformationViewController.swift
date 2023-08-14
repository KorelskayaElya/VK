//
//  FurtherInformationViewController.swift
//  VK
//
//  Created by Эля Корельская on 14.08.2023.
//

import UIKit

class FurtherInformationViewController: UIViewController {

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
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    private lazy var nameLabel = LabelField()
    private lazy var surnameLabel = LabelField()
    private lazy var genderLabel = LabelField()
    private lazy var birthdayLabel = LabelField()
    private lazy var cityLabel = LabelField()
    private lazy var hobbyLabel = LabelField()
    private lazy var schoolLabel = LabelField()
    private lazy var univercityLabel = LabelField()
    private lazy var workLabel = LabelField()
    
    func setupView() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        surnameLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        birthdayLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        hobbyLabel.translatesAutoresizingMaskIntoConstraints = false
        schoolLabel.translatesAutoresizingMaskIntoConstraints = false
        univercityLabel.translatesAutoresizingMaskIntoConstraints = false
        workLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Анна"
        surnameLabel.text = "Мищенко"
        genderLabel.text = "Женский"
        birthdayLabel.text = "01.01.1993"
        cityLabel.text = "Москва"
        hobbyLabel.text = "балет"
        schoolLabel.text = "Школа 123"
        univercityLabel.text = "Московский государственный"
        workLabel.text = "Балерина"
        view.addSubview(nameLabel)
        view.addSubview(surnameLabel)
        view.addSubview(genderLabel)
        view.addSubview(birthdayLabel)
        view.addSubview(cityLabel)
        view.addSubview(hobbyLabel)
        view.addSubview(schoolLabel)
        view.addSubview(univercityLabel)
        view.addSubview(workLabel)
    }
    func constraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.widthAnchor.constraint(equalToConstant: 300),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            surnameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            surnameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            surnameLabel.widthAnchor.constraint(equalToConstant: 300),
            surnameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            genderLabel.topAnchor.constraint(equalTo: surnameLabel.bottomAnchor, constant: 20),
            genderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            genderLabel.widthAnchor.constraint(equalToConstant: 300),
            genderLabel.heightAnchor.constraint(equalToConstant: 20),
            
            birthdayLabel.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 20),
            birthdayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            birthdayLabel.widthAnchor.constraint(equalToConstant: 300),
            birthdayLabel.heightAnchor.constraint(equalToConstant: 20),
            
            cityLabel.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: 20),
            cityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cityLabel.widthAnchor.constraint(equalToConstant: 300),
            cityLabel.heightAnchor.constraint(equalToConstant: 20),
            
            hobbyLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 20),
            hobbyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            hobbyLabel.widthAnchor.constraint(equalToConstant: 300),
            hobbyLabel.heightAnchor.constraint(equalToConstant: 20),
            
            schoolLabel.topAnchor.constraint(equalTo: hobbyLabel.bottomAnchor, constant: 20),
            schoolLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            schoolLabel.widthAnchor.constraint(equalToConstant: 300),
            schoolLabel.heightAnchor.constraint(equalToConstant: 20),
            
            univercityLabel.topAnchor.constraint(equalTo: schoolLabel.bottomAnchor, constant: 20),
            univercityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            univercityLabel.widthAnchor.constraint(equalToConstant: 300),
            univercityLabel.heightAnchor.constraint(equalToConstant: 20),
            
            workLabel.topAnchor.constraint(equalTo: univercityLabel.bottomAnchor, constant: 20),
            workLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            workLabel.widthAnchor.constraint(equalToConstant: 300),
            workLabel.heightAnchor.constraint(equalToConstant: 20),
            
            
            
        ])
    }
}
