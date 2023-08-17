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
// добавить пост в profilevc
class PostAddViewController: UIViewController {
    
    // MARK: - UI
    /// поле ввода текста для поста
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
    /// лейбл
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Add you text:".localized
        label.textColor = UIColor(named: "Black")
        label.font = UIFont(name: "Arial", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    /// лейбл
    private lazy var photoLabel: UILabel = {
        let label = UILabel()
        label.text = "Add you photo".localized
        label.textColor = UIColor(named: "Orange")
        label.font = UIFont(name: "Arial", size: 20)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addPhoto))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textAlignment = .center
        
        return label
    }()
    /// кнопка публикации поста
    private lazy var buttonSend: UIButton = {
        let button = UIButton()
        button.setTitle("Add Post".localized, for: .normal)
        button.backgroundColor = UIColor(named: "Orange")
        button.titleLabel?.font = UIFont(name: "Arial", size: 15)
        button.setTitleColor(UIColor(named: "Black"), for: .normal)
        button.addTarget(self, action: #selector(sendPost), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        return button
    }()
    // MARK: - Properties
    weak var delegate: PostAddViewControllerDelegate?
    private var selectedImage: UIImage?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Добавить пост".localized
        view.addSubview(textPostField)
        view.addSubview(photoLabel)
        view.addSubview(textLabel)
        view.addSubview(buttonSend)
        constraints()
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "backarrow"), for: .normal)
        backButton.tintColor = UIColor(named: "Orange")
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    private func constraints() {
        NSLayoutConstraint.activate([
            self.textLabel.topAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.textLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            self.textLabel.widthAnchor.constraint(equalToConstant: 200),
            self.textLabel.heightAnchor.constraint(equalToConstant: 20),
            
            self.textPostField.topAnchor.constraint(equalTo: self.textLabel.bottomAnchor, constant: 16),
            self.textPostField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.textPostField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.textPostField.heightAnchor.constraint(equalToConstant: 200),
            
            self.photoLabel.topAnchor.constraint(equalTo: self.textPostField.bottomAnchor, constant: 15),
            self.photoLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.photoLabel.widthAnchor.constraint(equalToConstant: 220),
            self.photoLabel.heightAnchor.constraint(equalToConstant: 30),
            
            self.buttonSend.topAnchor.constraint(equalTo: self.photoLabel.bottomAnchor, constant: 20),
            self.buttonSend.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            self.buttonSend.widthAnchor.constraint(equalToConstant: 120),
            self.buttonSend.heightAnchor.constraint(equalToConstant: 50),

        ])
    }
   
    // MARK: - Private
    /// кнопка пеерехода назад
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    /// кнопка добаваить изображение
    @objc private func addPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    /// кнопка опубликовать пост
    @objc private func sendPost() {
        guard let text = textPostField.text else { return }
        let newPost = Post(user: User(identifier: "annaux_designer",
                                      username: "Анна Мищенко",
                                      profilePicture: UIImage(named:"header1"),
                                      status: "дизайнер",
                                      gender: "Женский",
                                      birthday: "01.02.1997",
                                      city: "Москва",
                                      hobby: "футбол",
                                      school:"Дизайнер",
                                      university: "школа 134",
                                      work: "Московский"),
                           textPost: text,
                           imagePost: selectedImage)
        
        delegate?.postAddViewController(self, didCreatePost: newPost)

        navigationController?.popViewController(animated: true)
    }
}

extension PostAddViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
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
        return newText.count <= 300
    }
}
