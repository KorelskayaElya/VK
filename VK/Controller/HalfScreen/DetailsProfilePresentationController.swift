//
//  HalfScreenPresentationController.swift
//  VK
//
//  Created by Эля Корельская on 29.07.2023.
//

import UIKit

protocol DetailsProfileToSaveDelegate: AnyObject {
    func detailsProfileToSave()
}

protocol DetailsProfileToFilesDelegate: AnyObject {
    func detailsProfileToFiles()
}
/// дополнительно в профиле
class DetailsProfilePresentationController: UIPresentationController {
    
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
    
    // MARK: - Properties
    var user: User
    weak var detailsProfileToSaveDelegate: DetailsProfileToSaveDelegate?
    weak var detailsProfileToFilesDelagate: DetailsProfileToFilesDelegate?
    
    
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
        /// кнопка выхода
        arrowButton.addTarget(self, action: #selector(dismissModalController), for: .touchUpInside)
        arrowButton.contentVerticalAlignment = .fill
        arrowButton.contentHorizontalAlignment = .fill
        /// имя в профиле
        let customLabel1 = LabelField()
        customLabel1.text = user.username
        customLabel1.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        customLabel1.translatesAutoresizingMaskIntoConstraints = false
        /// линия разделения
        let lineView1 = LineView()
        /// иконка лейбла закладки
        let starIconView = UIImageView(image: IconImageUtility.iconImage(named: "star.fill", tintColor: .black))
        starIconView.tintColor = .black
        starIconView.translatesAutoresizingMaskIntoConstraints = false
        /// икнока лейбла файлы
        let squareIconView = UIImageView(image: IconImageUtility.iconImage(named: "square.and.arrow.up", tintColor: .black))
        squareIconView.tintColor = .black
        squareIconView.translatesAutoresizingMaskIntoConstraints = false
        /// лейбл закладки
        let customLabel2 = LabelField()
        customLabel2.text = "Saved".localized
        customLabel2.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(didSave))
        customLabel2.isUserInteractionEnabled = true
        customLabel2.addGestureRecognizer(tapGesture1)
        customLabel2.translatesAutoresizingMaskIntoConstraints = false
        /// лейбл файлы
        let customLabel3 = LabelField()
        customLabel3.text = "Files".localized
        customLabel3.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(didFiles))
        customLabel3.isUserInteractionEnabled = true
        customLabel3.addGestureRecognizer(tapGesture2)
        customLabel3.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(dimmingView)
        presentedViewController.view.addSubview(arrowButton)
        presentedViewController.view.addSubview(lineView1)
        presentedViewController.view.addSubview(customLabel1)
        presentedViewController.view.addSubview(starIconView)
        presentedViewController.view.addSubview(squareIconView)
        presentedViewController.view.addSubview(customLabel2)
        presentedViewController.view.addSubview(customLabel3)
        
      
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
        /// имя аккаунта
        customLabel1.topAnchor.constraint(equalTo: arrowButton.bottomAnchor, constant: 16),
        customLabel1.leadingAnchor.constraint(equalTo: presentedViewController.view.leadingAnchor, constant: 16),
        /// линия разделения
        lineView1.topAnchor.constraint(equalTo: customLabel1.bottomAnchor, constant: 8),
        lineView1.leadingAnchor.constraint(equalTo: presentedViewController.view.leadingAnchor, constant: 16),
        lineView1.trailingAnchor.constraint(equalTo: presentedViewController.view.trailingAnchor, constant: -16),
        /// иконка звезды
        starIconView.leadingAnchor.constraint(equalTo:presentedViewController.view.leadingAnchor, constant: 15),
        starIconView.topAnchor.constraint(equalTo: lineView1.bottomAnchor, constant: 11),
        starIconView.widthAnchor.constraint(equalToConstant: 22),
        starIconView.heightAnchor.constraint(equalTo: starIconView.widthAnchor),
        /// иконка поделиться
        squareIconView.leadingAnchor.constraint(equalTo:presentedViewController.view.leadingAnchor, constant: 15),
        squareIconView.topAnchor.constraint(equalTo: starIconView.bottomAnchor, constant: 11),
        squareIconView.widthAnchor.constraint(equalToConstant: 22),
        squareIconView.heightAnchor.constraint(equalTo: squareIconView.widthAnchor),
        /// лейбл закладки
        customLabel2.topAnchor.constraint(equalTo: lineView1.bottomAnchor, constant: 14),
        customLabel2.leadingAnchor.constraint(equalTo: starIconView.trailingAnchor, constant: 6),
        /// лейбл файлы
        customLabel3.topAnchor.constraint(equalTo: customLabel2.bottomAnchor, constant: 15),
        customLabel3.leadingAnchor.constraint(equalTo: squareIconView.trailingAnchor, constant: 6),
        
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
    /// открыть заклыдки
    @objc private func didSave() {
        detailsProfileToSaveDelegate?.detailsProfileToSave()
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    /// открыть файлы
    @objc private func didFiles() {
        detailsProfileToFilesDelagate?.detailsProfileToFiles()
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    /// расположение вью на 3/4 экрана
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
