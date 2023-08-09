//
//  HalfScreenPresentationController.swift
//  VK
//
//  Created by Эля Корельская on 29.07.2023.
//

import UIKit
protocol HalfScreenPresentationControllerDelegate: AnyObject {
    func didTapSettings()
}

class HalfScreenPresentationController: UIPresentationController {
    
    var user: User
    weak var halfScreenDelegate: HalfScreenPresentationControllerDelegate?
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, user: User) {
        self.user = user
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    // затемнение
    private let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let arrowButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = UIColor(named: "Orange")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        // цвет бокового окна
        presentedViewController.view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 220/255, alpha: 1.0)
        presentedViewController.view.clipsToBounds = true
        guard let containerView = containerView else { return }
        arrowButton.addTarget(self, action: #selector(dismissModalController), for: .touchUpInside)
        arrowButton.contentVerticalAlignment = .fill
        arrowButton.contentHorizontalAlignment = .fill
        let customLabel1 = LabelField()
        customLabel1.text = user.username
        customLabel1.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        customLabel1.translatesAutoresizingMaskIntoConstraints = false
        let lineView1 = LineView()
        let lineView2 = LineView()
        let heartIconView = UIImageView(image: IconImageUtility.iconImage(named: "heart.fill", tintColor: .black))
        heartIconView.tintColor = .black
        heartIconView.translatesAutoresizingMaskIntoConstraints = false

        let starIconView = UIImageView(image: IconImageUtility.iconImage(named: "star.fill", tintColor: .black))
        starIconView.tintColor = .black
        starIconView.translatesAutoresizingMaskIntoConstraints = false

        let squareIconView = UIImageView(image: IconImageUtility.iconImage(named: "square.and.arrow.up", tintColor: .black))
        squareIconView.tintColor = .black
        squareIconView.translatesAutoresizingMaskIntoConstraints = false

        let archiveboxIconView = UIImageView(image: IconImageUtility.iconImage(named: "archivebox.fill", tintColor: .black))
        archiveboxIconView.tintColor = .black
        archiveboxIconView.translatesAutoresizingMaskIntoConstraints = false

        let gearshapeIconView = UIImageView(image: IconImageUtility.iconImage(named: "gearshape.fill", tintColor: .black))
        gearshapeIconView.tintColor = .black
        gearshapeIconView.translatesAutoresizingMaskIntoConstraints = false

        let customLabel2 = LabelField()
        customLabel2.text = "Закладки"
        customLabel2.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        customLabel2.translatesAutoresizingMaskIntoConstraints = false
        let customLabel3 = LabelField()
        customLabel3.text = "Понравилось"
        customLabel3.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        customLabel3.translatesAutoresizingMaskIntoConstraints = false
        let customLabel4 = LabelField()
        customLabel4.text = "Файлы"
        customLabel4.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        customLabel4.translatesAutoresizingMaskIntoConstraints = false
        let customLabel5 = LabelField()
        customLabel5.text = "Архивы"
        customLabel5.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        customLabel5.translatesAutoresizingMaskIntoConstraints = false
        let customLabel6 = LabelField()
        customLabel6.text = "Настройки"
        customLabel6.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        customLabel6.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSettingsTap))
        customLabel6.isUserInteractionEnabled = true
        customLabel6.addGestureRecognizer(tapGesture)

        
        
        containerView.addSubview(dimmingView)
        presentedViewController.view.addSubview(arrowButton)
        presentedViewController.view.addSubview(lineView1)
        presentedViewController.view.addSubview(lineView2)
        presentedViewController.view.addSubview(customLabel1)
        presentedViewController.view.addSubview(heartIconView)
        presentedViewController.view.addSubview(starIconView)
        presentedViewController.view.addSubview(squareIconView)
        presentedViewController.view.addSubview(archiveboxIconView)
        presentedViewController.view.addSubview(gearshapeIconView)
        presentedViewController.view.addSubview(customLabel2)
        presentedViewController.view.addSubview(customLabel3)
        presentedViewController.view.addSubview(customLabel4)
        presentedViewController.view.addSubview(customLabel5)
        presentedViewController.view.addSubview(customLabel6)
        
      
       NSLayoutConstraint.activate([
        // затемнение
        dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor),
        dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
        dimmingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        // стрелка назад
        arrowButton.topAnchor.constraint(equalTo: presentedViewController.view.safeAreaLayoutGuide.topAnchor, constant: 16),
        arrowButton.leadingAnchor.constraint(equalTo: presentedViewController.view.leadingAnchor, constant: 10),
        arrowButton.widthAnchor.constraint(equalToConstant: 30),
        arrowButton.heightAnchor.constraint(equalToConstant: 20),
        // имя аккаунта
        customLabel1.topAnchor.constraint(equalTo: arrowButton.bottomAnchor, constant: 16),
        customLabel1.leadingAnchor.constraint(equalTo: presentedViewController.view.leadingAnchor, constant: 16),
        // линия разделения
        lineView1.topAnchor.constraint(equalTo: customLabel1.bottomAnchor, constant: 8),
        lineView1.leadingAnchor.constraint(equalTo: presentedViewController.view.leadingAnchor, constant: 16),
        lineView1.trailingAnchor.constraint(equalTo: presentedViewController.view.trailingAnchor, constant: -16),
        // иконка звезды
        starIconView.leadingAnchor.constraint(equalTo:presentedViewController.view.leadingAnchor, constant: 15),
        starIconView.topAnchor.constraint(equalTo: lineView1.bottomAnchor, constant: 11),
        starIconView.widthAnchor.constraint(equalToConstant: 22),
        starIconView.heightAnchor.constraint(equalTo: starIconView.widthAnchor),
        // иконка сердца
        heartIconView.leadingAnchor.constraint(equalTo:presentedViewController.view.leadingAnchor, constant: 15),
        heartIconView.topAnchor.constraint(equalTo: starIconView.bottomAnchor, constant: 11),
        heartIconView.widthAnchor.constraint(equalToConstant: 22),
        heartIconView.heightAnchor.constraint(equalTo: heartIconView.widthAnchor),
        // иконка поделиться
        squareIconView.leadingAnchor.constraint(equalTo:presentedViewController.view.leadingAnchor, constant: 15),
        squareIconView.topAnchor.constraint(equalTo: heartIconView.bottomAnchor, constant: 11),
        squareIconView.widthAnchor.constraint(equalToConstant: 22),
        squareIconView.heightAnchor.constraint(equalTo: squareIconView.widthAnchor),
        // иконка архив
        archiveboxIconView.leadingAnchor.constraint(equalTo:presentedViewController.view.leadingAnchor, constant: 15),
        archiveboxIconView.topAnchor.constraint(equalTo: squareIconView.bottomAnchor, constant: 11),
        archiveboxIconView.widthAnchor.constraint(equalToConstant: 22),
        archiveboxIconView.heightAnchor.constraint(equalTo: archiveboxIconView.widthAnchor),
        // иконка настройки
        gearshapeIconView.leadingAnchor.constraint(equalTo:presentedViewController.view.leadingAnchor, constant: 15),
        gearshapeIconView.topAnchor.constraint(equalTo: lineView2.bottomAnchor, constant: 11),
        gearshapeIconView.widthAnchor.constraint(equalToConstant: 22),
        gearshapeIconView.heightAnchor.constraint(equalTo: gearshapeIconView.widthAnchor),
        // лейбл закладки
        customLabel2.topAnchor.constraint(equalTo: lineView1.bottomAnchor, constant: 14),
        customLabel2.leadingAnchor.constraint(equalTo: starIconView.trailingAnchor, constant: 6),
        // лейбл понравилось
        customLabel3.topAnchor.constraint(equalTo: customLabel2.bottomAnchor, constant: 15),
        customLabel3.leadingAnchor.constraint(equalTo: heartIconView.trailingAnchor, constant: 6),
        // лейбл файлы
        customLabel4.topAnchor.constraint(equalTo: customLabel3.bottomAnchor, constant: 16),
        customLabel4.leadingAnchor.constraint(equalTo: squareIconView.trailingAnchor, constant: 6),
        // лейбл архив
        customLabel5.topAnchor.constraint(equalTo: customLabel4.bottomAnchor, constant: 17),
        customLabel5.leadingAnchor.constraint(equalTo: archiveboxIconView.trailingAnchor, constant: 6),
        // линия разделения
        lineView2.topAnchor.constraint(equalTo: customLabel5.bottomAnchor, constant: 15),
        lineView2.leadingAnchor.constraint(equalTo: presentedViewController.view.leadingAnchor, constant: 16),
        lineView2.trailingAnchor.constraint(equalTo: presentedViewController.view.trailingAnchor, constant: -16),
        // лейбл настройки
        customLabel6.topAnchor.constraint(equalTo: lineView2.bottomAnchor, constant: 15),
        customLabel6.leadingAnchor.constraint(equalTo: gearshapeIconView.trailingAnchor, constant: 6),
        
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
    func didTapSettings() {
        let settingsVC = SettingsViewController(user: user)
        if let navigationController = presentingViewController as? UINavigationController {
            navigationController.pushViewController(settingsVC, animated: true)
        }
        presentingViewController.dismiss(animated: true, completion: nil)
    }

       
    @objc func handleSettingsTap() {
        halfScreenDelegate?.didTapSettings()
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return CGRect.zero
        }
        return CGRect(x: containerView.bounds.width / 4, y: 0, width: containerView.bounds.width * 3 / 4, height: containerView.bounds.height)
    }
    
    @objc func dismissModalController() {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}
