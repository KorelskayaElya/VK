//
//  DataViewController.swift
//  VK
//
//  Created by Эля Корельская on 16.08.2023.
//

import UIKit

class DataViewController: UIViewController {
    
    // MARK: - Properties
    var image: UIImage?
    var shareButton: UIBarButtonItem!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        /// Добавить кнопку "Поделиться"
        shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
        navigationItem.rightBarButtonItem = shareButton
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "backarrow"), for: .normal)
        backButton.tintColor = UIColor(named: "Orange")
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
        ])
    }
    // MARK: - Private
    /// поделиться
    @objc private func shareButtonTapped() {
        let activityViewController = UIActivityViewController(activityItems: [self.image!], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = shareButton
        present(activityViewController, animated: true, completion: nil)
    }
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
