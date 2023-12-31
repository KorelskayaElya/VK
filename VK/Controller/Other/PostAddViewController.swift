//
//  PostAddViewController.swift
//  VK
//
//  Created by Эля Корельская on 12.08.2023.
//

import UIKit

/// добавить пост в profilevc
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
    private var selectedImage: UIImage?
    var receivedUsername = ""
    var recievedStatus = ""
    lazy var path = ""
    var isProfileImageChanged = false
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
            textLabel.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            textLabel.widthAnchor.constraint(equalToConstant: 200),
            textLabel.heightAnchor.constraint(equalToConstant: 20),
            
            textPostField.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 16),
            textPostField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textPostField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textPostField.heightAnchor.constraint(equalToConstant: 200),
            
            photoLabel.topAnchor.constraint(equalTo: textPostField.bottomAnchor, constant: 15),
            photoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            photoLabel.widthAnchor.constraint(equalToConstant: 220),
            photoLabel.heightAnchor.constraint(equalToConstant: 30),
            
            buttonSend.topAnchor.constraint(equalTo: photoLabel.bottomAnchor, constant: 20),
            buttonSend.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            buttonSend.widthAnchor.constraint(equalToConstant: 120),
            buttonSend.heightAnchor.constraint(equalToConstant: 50),

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
        
        view.endEditing(true)
        
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            var imageJpeg: Data?
            if let image = self.selectedImage {
                imageJpeg = image.jpegData(compressionQuality: 0.7)
            }
            let defaultUsername = self.receivedUsername.isEmpty ? "Анна Мищенко" : self.receivedUsername
            let defaultStatus = self.recievedStatus.isEmpty ? "Дизайнер" : self.recievedStatus
            
            var profilePictureData: Data?
            if !self.path.isEmpty  {
                profilePictureData = UIImage(named: "header1")?.pngData()
            }
            if !self.path.isEmpty && self.isProfileImageChanged == true {
                let profileImage = UIImage(contentsOfFile: self.path)
                profilePictureData = profileImage?.pngData()
            }
            
            CoreDataService.shared.addPost(
                username: defaultUsername,
                status: defaultStatus,
                profilePicture: profilePictureData,
                text: text,
                image: imageJpeg
            )
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
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
