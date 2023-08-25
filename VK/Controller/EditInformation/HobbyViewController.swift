//
//  HobbyViewController.swift
//  VK
//
//  Created by Эля Корельская on 14.08.2023.
//

import UIKit
protocol HobbyViewControllerDelegate: AnyObject {
    func hobbyViewControllerDidFinishEnteringInfo(hobby: String)
}
/// интересы
class HobbyViewController: UIViewController {
    // MARK: - UI
    private lazy var hobbyLabel = LabelField()
    private lazy var hobbyField: UITextField = {
        let field = UITextField()
        field.placeholder = "hobby".localized
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
    weak var delegate: HobbyViewControllerDelegate?
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
        navigationItem.title = "Hobby".localized
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
        hobbyField.delegate = self
        setUserInfo()
        
        
    }
    // MARK: - Private
    private func setUserInfo() {
        hobbyField.text = user?.hobby
    }
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc private func nextButtonTapped() {
        let hobby = hobbyField.text ?? ""
        
        delegate?.hobbyViewControllerDidFinishEnteringInfo(hobby: hobby)
        
        navigationController?.popViewController(animated: true)
    }
    private func setupView() {
        hobbyLabel.text = "Hobby".localized
        view.addSubview(hobbyLabel)
        view.addSubview(hobbyField)
        hobbyLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func constraints() {
        NSLayoutConstraint.activate([
            hobbyLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            hobbyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            hobbyLabel.widthAnchor.constraint(equalToConstant: 100),
            hobbyLabel.heightAnchor.constraint(equalToConstant: 20),
            
            hobbyField.topAnchor.constraint(equalTo: hobbyLabel.bottomAnchor, constant: 5),
            hobbyField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            hobbyField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            hobbyField.heightAnchor.constraint(equalToConstant: 30),
    ])
    }
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension HobbyViewController: UITextFieldDelegate {
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
