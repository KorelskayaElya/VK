//
//  WorkViewController.swift
//  VK
//
//  Created by Эля Корельская on 14.08.2023.
//

import UIKit
protocol WorkViewControllerDelegate: AnyObject {
    func workViewControllerDidFinishEnteringInfo(work: String)
}
// текущее место работы
class WorkViewController: UIViewController {
    
    // MARK: - UI
    private lazy var workLabel = LabelField()
    private lazy var workField: UITextField = {
        let field = UITextField()
        field.placeholder = "работа".localized
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
    weak var delegate: WorkViewControllerDelegate?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Карьера".localized
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
        workField.delegate = self
        
    }
    // MARK: - Private
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    private func setupView() {
        workLabel.text = "Работа".localized
        view.addSubview(workLabel)
        view.addSubview(workField)
        workLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func constraints() {
        NSLayoutConstraint.activate([
            workLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            workLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            workLabel.widthAnchor.constraint(equalToConstant: 100),
            workLabel.heightAnchor.constraint(equalToConstant: 20),
            
            workField.topAnchor.constraint(equalTo: workLabel.bottomAnchor, constant: 5),
            workField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            workField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            workField.heightAnchor.constraint(equalToConstant: 30),
    ])
    }
    @objc private func nextButtonTapped() {
        let work = workField.text ?? ""
        delegate?.workViewControllerDidFinishEnteringInfo(work: work)
        
        navigationController?.popViewController(animated: true)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension WorkViewController: UITextFieldDelegate {
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
