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
        
        ///Добавить UIImageView на экран и отобразить на нем изображение.
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    // MARK: - Private
    /// поделиться
    @objc private func shareButtonTapped() {
        let activityViewController = UIActivityViewController(activityItems: [self.image!], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = shareButton
        present(activityViewController, animated: true, completion: nil)
    }
}
