//
//  EditProfile.swift
//  VK
//
//  Created by Эля Корельская on 06.08.2023.
//
import UIKit

protocol EditMainInformationDelegate: AnyObject {
    func editMainInformation()
}
protocol EditHobbyDelegate: AnyObject {
    func editHobby()
}
protocol EditEducationDelegate: AnyObject {
    func editEducation()
}
protocol EditWorkDelegate: AnyObject {
    func editWork()
}
// редактировать профиль
class EditProfilePresentationController: UIPresentationController {
    
    // MARK: - UI
    /// затемнение
    private let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    /// кнопка назад
    private let arrowButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = UIColor(named: "Orange")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: -  Properties
    var user: User
    weak var editMainInformationDelagete: EditMainInformationDelegate?
    weak var editHobbyDelegate: EditHobbyDelegate?
    weak var editEducationDelegate: EditEducationDelegate?
    weak var editWorkDelegate: EditWorkDelegate?
    
    // MARK: - Init
   
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, user: User) {
        self.user = user
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
   
    // MARK: - Lifecycle
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        /// цвет бокового окна
        presentedViewController.view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 220/255, alpha: 1.0)
        presentedViewController.view.clipsToBounds = true
        /// контейнер
        guard let containerView = containerView else { return }
        /// кнопка назад
        arrowButton.addTarget(self, action: #selector(dismissModalController), for: .touchUpInside)
        arrowButton.contentVerticalAlignment = .fill
        arrowButton.contentHorizontalAlignment = .fill
        /// лейбл профиль
        let customLabel1 = LabelField()
        customLabel1.text = "Профиль"
        customLabel1.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        customLabel1.translatesAutoresizingMaskIntoConstraints = false
        /// линия разделения
        let lineView1 = LineView()
        /// лейбл основная информация
        let customLabel2 = LabelField()
        customLabel2.text = "Основная информация"
        customLabel2.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(didAddInformation))
        customLabel2.isUserInteractionEnabled = true
        customLabel2.addGestureRecognizer(tapGesture1)
        customLabel2.translatesAutoresizingMaskIntoConstraints = false
        /// лейбл интересы
        let customLabel3 = LabelField()
        customLabel3.text = "Интересы"
        customLabel3.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(didAddHobby))
        customLabel3.isUserInteractionEnabled = true
        customLabel3.addGestureRecognizer(tapGesture2)
        customLabel3.translatesAutoresizingMaskIntoConstraints = false
        /// лейбл образование
        let customLabel4 = LabelField()
        customLabel4.text = "Образование"
        customLabel4.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(didAddEducation))
        customLabel4.isUserInteractionEnabled = true
        customLabel4.addGestureRecognizer(tapGesture3)
        customLabel4.translatesAutoresizingMaskIntoConstraints = false
        /// лейбл карьера
        let customLabel5 = LabelField()
        customLabel5.text = "Карьера"
        customLabel5.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        let tapGesture4 = UITapGestureRecognizer(target: self, action: #selector(didAddWork))
        customLabel5.isUserInteractionEnabled = true
        customLabel5.addGestureRecognizer(tapGesture4)
        customLabel5.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(dimmingView)
        presentedViewController.view.addSubview(arrowButton)
        presentedViewController.view.addSubview(lineView1)
        presentedViewController.view.addSubview(customLabel1)
        presentedViewController.view.addSubview(customLabel2)
        presentedViewController.view.addSubview(customLabel3)
        presentedViewController.view.addSubview(customLabel4)
        presentedViewController.view.addSubview(customLabel5)
        
      
       NSLayoutConstraint.activate([
        /// затемнение
        dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor),
        dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
        dimmingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        /// стрелка назад
        arrowButton.topAnchor.constraint(equalTo: presentedViewController.view.safeAreaLayoutGuide.topAnchor, constant: 16),
        arrowButton.leadingAnchor.constraint(equalTo: presentedViewController.view.leadingAnchor, constant: 10),
        arrowButton.widthAnchor.constraint(equalToConstant: 30),
        arrowButton.heightAnchor.constraint(equalToConstant: 20),
        /// профиль
        customLabel1.topAnchor.constraint(equalTo: arrowButton.bottomAnchor, constant: 16),
        customLabel1.leadingAnchor.constraint(equalTo: presentedViewController.view.leadingAnchor, constant: 16),
        /// линия разделения
        lineView1.topAnchor.constraint(equalTo: customLabel1.bottomAnchor, constant: 8),
        lineView1.leadingAnchor.constraint(equalTo: presentedViewController.view.leadingAnchor, constant: 16),
        lineView1.trailingAnchor.constraint(equalTo: presentedViewController.view.trailingAnchor, constant: -16),
        /// лейбл основная информация
        customLabel2.topAnchor.constraint(equalTo: lineView1.bottomAnchor, constant: 14),
        customLabel2.leadingAnchor.constraint(equalTo: presentedViewController.view.leadingAnchor, constant: 16),
        /// лейбл интересы
        customLabel3.topAnchor.constraint(equalTo: customLabel2.bottomAnchor, constant: 15),
        customLabel3.leadingAnchor.constraint(equalTo: presentedViewController.view.leadingAnchor, constant: 16),
        /// лейбл образование
        customLabel4.topAnchor.constraint(equalTo: customLabel3.bottomAnchor, constant: 16),
        customLabel4.leadingAnchor.constraint(equalTo: presentedViewController.view.leadingAnchor, constant: 16),
        /// лейбл карьера
        customLabel5.topAnchor.constraint(equalTo: customLabel4.bottomAnchor, constant: 17),
        customLabel5.leadingAnchor.constraint(equalTo: presentedViewController.view.leadingAnchor, constant: 16),
        
        ])
        if let presentedView = presentedView {
            containerView.addSubview(presentedView)
            presentedView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                presentedView.topAnchor.constraint(equalTo: containerView.topAnchor),
                presentedView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                presentedView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                presentedView.widthAnchor.constraint(equalToConstant: containerView.bounds.width * 3 / 4)
            ])
        }
            
    }
    // MARK: - Private
    /// переход на "основная информация"
    @objc private func didAddInformation() {
        editMainInformationDelagete?.editMainInformation()
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    /// переход на "интересы"
    @objc private func didAddHobby() {
        editHobbyDelegate?.editHobby()
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    /// переход на "образование"
    @objc private func didAddEducation() {
        editEducationDelegate?.editEducation()
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    /// переход на "карьера"
    @objc private func didAddWork() {
        editWorkDelegate?.editWork()
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    /// показать вью на 3/4 экрана
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return CGRect.zero
        }
        return CGRect(x: containerView.bounds.width / 4, y: 0, width: containerView.bounds.width * 3 / 4, height: containerView.bounds.height)
    }
    /// выход назад
    @objc private func dismissModalController() {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}

