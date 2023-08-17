//
//  EducationViewController.swift
//  VK
//
//  Created by Эля Корельская on 14.08.2023.
//
import UIKit
protocol EducationViewControllerDelegate: AnyObject {
    func educationViewControllerDidFinishEnteringInfo(school: String, university: String)
}
// образование
class EducationViewController: UIViewController {
    // MARK: - UI
    private lazy var schoolLabel = LabelField()
    private lazy var univercityLabel = LabelField()
    private lazy var schoolField: UITextField = {
        let field = UITextField()
        field.placeholder = "школа".localized
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
    private lazy var unisercityField: UITextField = {
        let field = UITextField()
        field.placeholder = "университет".localized
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
    weak var educationDelegate: EducationViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Образование".localized
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        schoolField.delegate = self
        unisercityField.delegate = self
        
    }
    // MARK: - Private
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc private func nextButtonTapped() {
        let school = schoolField.text ?? ""
        let university = unisercityField.text ?? ""
        educationDelegate?.educationViewControllerDidFinishEnteringInfo(school: school, university: university)
        
        navigationController?.popViewController(animated: true)
    }
    private func setupView() {
        schoolLabel.text = "Школа".localized
        univercityLabel.text = "Университет".localized
        view.addSubview(schoolLabel)
        view.addSubview(univercityLabel)
        view.addSubview(schoolField)
        view.addSubview(unisercityField)
        schoolLabel.translatesAutoresizingMaskIntoConstraints = false
        univercityLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func constraints() {
        NSLayoutConstraint.activate([
            schoolLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            schoolLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            schoolLabel.widthAnchor.constraint(equalToConstant: 100),
            schoolLabel.heightAnchor.constraint(equalToConstant: 20),
            
            schoolField.topAnchor.constraint(equalTo: schoolLabel.bottomAnchor, constant: 5),
            schoolField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            schoolField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            schoolField.heightAnchor.constraint(equalToConstant: 30),
            
            
            univercityLabel.topAnchor.constraint(equalTo: schoolField.bottomAnchor, constant: 30),
            univercityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            univercityLabel.widthAnchor.constraint(equalToConstant: 100),
            univercityLabel.heightAnchor.constraint(equalToConstant: 20),
            
            unisercityField.topAnchor.constraint(equalTo: univercityLabel.bottomAnchor, constant: 5),
            unisercityField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            unisercityField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            unisercityField.heightAnchor.constraint(equalToConstant: 30),
        
    ])
    }
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension EducationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 40
    }
}

