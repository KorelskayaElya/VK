//
//  InformationViewController.swift
//  VK
//
//  Created by Эля Корельская on 14.08.2023.
//

import UIKit
protocol InformationViewControllerDelegate: AnyObject {
    func informationViewControllerDidFinishEnteringInfo(username: String, gender: String, birthday: String, city: String, status: String)
}
// основная информация 
class InformationViewController: UIViewController {
    
    // MARK: - UI
    private lazy var usernameLabel = LabelField()
    private lazy var genderLabel = LabelField()
    private lazy var maleLabel = LabelField()
    private lazy var femaleLabel = LabelField()
    private lazy var statusLabel = LabelField()
    private lazy var birthdayLabel = LabelField()
    private lazy var cityLabel = LabelField()
    private lazy var dotmale = RoundButtonWithDot()
    private lazy var dotfemale = RoundButtonWithDot()
    
    private lazy var usernameField: UITextField = {
        let field = UITextField()
        field.placeholder = "имя фамилия".localized
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
    
    private lazy var statusField: UITextField = {
        let field = UITextField()
        field.placeholder = "статус".localized
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
        field.placeholder = "Напишите название".localized
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
    // MARK: - Properties
    var user: User?
    weak var delegate: InformationViewControllerDelegate?

    // MARK: - Init
    init(user: User?) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Основная информация".localized
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
        setUserInfo()
        
    }
    // MARK: - Private
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupView() {
        usernameLabel.text = "Имя Фамилия".localized
        genderLabel.text = "Пол".localized
        maleLabel.text = "Мужской".localized
        statusLabel.text = "Статус".localized
        femaleLabel.text = "Женский".localized
        birthdayLabel.text = "Дата рождения".localized
        cityLabel.text = "Родной город".localized
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        maleLabel.translatesAutoresizingMaskIntoConstraints = false
        femaleLabel.translatesAutoresizingMaskIntoConstraints = false
        birthdayLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        dotmale.translatesAutoresizingMaskIntoConstraints = false
        dotfemale.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        usernameField.delegate = self
        birhdayField.delegate = self
        cityField.delegate = self
        statusField.delegate = self
        view.addSubview(usernameLabel)
        view.addSubview(genderLabel)
        view.addSubview(maleLabel)
        view.addSubview(femaleLabel)
        view.addSubview(birthdayLabel)
        view.addSubview(cityLabel)
        view.addSubview(usernameField)
        view.addSubview(birhdayField)
        view.addSubview(cityField)
        view.addSubview(dotmale)
        view.addSubview(dotfemale)
        view.addSubview(statusField)
        view.addSubview(statusLabel)
        dotmale.addTarget(self, action: #selector(dotMaleButtonTapped), for: .touchUpInside)
        dotfemale.addTarget(self, action: #selector(dotFemaleButtonTapped), for: .touchUpInside)
    }
    private func setUserInfo() {
        usernameField.text = user?.username
        statusField.text = user?.status
        birhdayField.text = user?.birthday
        cityField.text = user?.city
        if let gender = user?.gender, !gender.isEmpty {
            if gender == "Мужской".localized {
                dotMaleButtonTapped()
            } else {
                dotFemaleButtonTapped()
            }
        }
    }

    private func constraints() {
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameLabel.widthAnchor.constraint(equalToConstant: 200),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            usernameField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5),
            usernameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            usernameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            usernameField.heightAnchor.constraint(equalToConstant: 30),
            
            statusLabel.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 20),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.widthAnchor.constraint(equalToConstant: 200),
            statusLabel.heightAnchor.constraint(equalToConstant: 20),
            
            statusField.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 5),
            statusField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            statusField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            statusField.heightAnchor.constraint(equalToConstant: 30),
            
            
            genderLabel.topAnchor.constraint(equalTo: statusField.bottomAnchor, constant: 20),
            genderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            genderLabel.widthAnchor.constraint(equalToConstant: 100),
            genderLabel.heightAnchor.constraint(equalToConstant: 20),
            
            dotmale.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 15),
            dotmale.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dotmale.widthAnchor.constraint(equalToConstant: 25),
            dotmale.heightAnchor.constraint(equalToConstant: 25),
            
            dotfemale.topAnchor.constraint(equalTo: dotmale.bottomAnchor, constant: 5),
            dotfemale.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dotfemale.widthAnchor.constraint(equalToConstant: 25),
            dotfemale.heightAnchor.constraint(equalToConstant: 25),
            
            maleLabel.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 17),
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
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc private func nextButtonTapped() {
        let username = usernameField.text ?? ""
        let gender = dotmale.isDotVisible ? "Мужской".localized : "Женский".localized
        let birthday = birhdayField.text ?? ""
        let city = cityField.text ?? ""
        let status = statusField.text ?? ""
        
        delegate?.informationViewControllerDidFinishEnteringInfo(username: username, gender: gender, birthday: birthday, city: city, status: status)
        
        navigationController?.popViewController(animated: true)
    }
    

}
extension InformationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 20
    }
}

