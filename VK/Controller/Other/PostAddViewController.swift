//
//  PostAddViewController.swift
//  VK
//
//  Created by Эля Корельская on 12.08.2023.
//

import UIKit
protocol PostAddViewControllerDelegate: AnyObject {
    func postAddViewController(_ controller: PostAddViewController, didCreatePost post: Post)
}
class PostAddViewController: UIViewController {
    weak var delegate: PostAddViewControllerDelegate?
    private var selectedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Добавить пост"
        view.addSubview(textPostField)
        view.addSubview(photoLabel)
        view.addSubview(textLabel)
        view.addSubview(buttonSend)
        constraints()
    }
    private lazy var textPostField: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor(named: "Black")
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 5
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return textView
    }()
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Добавьте текст ниже:"
        label.textColor = UIColor(named: "Black")
        label.font = UIFont(name: "Arial", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private lazy var photoLabel: UILabel = {
        let label = UILabel()
        label.text = "Добавьте изображение"
        label.textColor = .blue
        label.font = UIFont(name: "Arial", size: 15)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addPhoto))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private lazy var buttonSend: UIButton = {
        let button = UIButton()
        button.setTitle("Опубликовать", for: .normal)
        button.backgroundColor = UIColor(named: "Orange")
        button.titleLabel?.font = UIFont(name: "Arial", size: 15)
        button.setTitleColor(UIColor(named: "Black"), for: .normal)
        button.addTarget(self, action: #selector(sendPost), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        return button
    }()

    @objc private func addPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    func constraints() {
        NSLayoutConstraint.activate([
            self.textLabel.topAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            self.textLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            self.textLabel.widthAnchor.constraint(equalToConstant: 200),
            self.textLabel.heightAnchor.constraint(equalToConstant: 20),
            
            self.textPostField.topAnchor.constraint(equalTo: self.textLabel.bottomAnchor, constant: 16),
            self.textPostField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.textPostField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.textPostField.heightAnchor.constraint(equalToConstant: 200),
            
            self.photoLabel.topAnchor.constraint(equalTo: self.textPostField.bottomAnchor, constant: 5),
            self.photoLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            self.photoLabel.widthAnchor.constraint(equalToConstant: 200),
            self.photoLabel.heightAnchor.constraint(equalToConstant: 20),
            
            self.buttonSend.topAnchor.constraint(equalTo: self.photoLabel.bottomAnchor, constant: 20),
            self.buttonSend.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            self.buttonSend.widthAnchor.constraint(equalToConstant: 100),
            self.buttonSend.heightAnchor.constraint(equalToConstant: 50),

        ])
    }
    @objc func sendPost() {
        guard let text = textPostField.text else { return }
        let newPost = Post(user: User(identifier: "annaux_designer", username: "Анна Мищенко", profilePicture: UIImage(named:"header1"), status: "дизайнер"), textPost: text, imagePost: selectedImage)
        
        delegate?.postAddViewController(self, didCreatePost: newPost) // Call delegate method

        navigationController?.popViewController(animated: true)
    }

}
extension PostAddViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            // Set the selected image
            selectedImage = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
extension PostAddViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let currentText = textView.text, let range = Range(range, in: currentText) else {
            return true
        }
        
        let newText = currentText.replacingCharacters(in: range, with: text)
        return newText.count <= 400
    }
}
