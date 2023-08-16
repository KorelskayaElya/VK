//
//  TextViewController.swift
//  VK
//
//  Created by Эля Корельская on 16.08.2023.
//

import UIKit

class TextViewController: UIViewController {
    
    // MARK: - Properties
    private let fileContents: String
    var shareButton: UIBarButtonItem!
    // MARK: - Init
    init(fileContents: String) {
        self.fileContents = fileContents
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Text file"
        /// Добавить кнопку "Поделиться"
        shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
        navigationItem.rightBarButtonItem = shareButton
        
        
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = fileContents
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    // MARK: - Private
    /// поделиться
    @objc private func shareButtonTapped() {
        let activityViewController = UIActivityViewController(activityItems: [self.fileContents], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = shareButton
        present(activityViewController, animated: true, completion: nil)
    }
}


