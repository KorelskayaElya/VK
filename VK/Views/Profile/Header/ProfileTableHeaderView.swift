//
//  ProfileTableHeaderView.swift
//  VK
//
//  Created by Эля Корельская on 29.07.2023.
//

import UIKit
/// сделать пост
protocol ProfileTableHeaderAddPostViewDelegate: AnyObject {
    func didTapCreatePost()
}
/// сделать историю
protocol ProfileCameraDelegate: AnyObject {
    func didTapCamera()
}
/// редактировать информацию
protocol ProfileEditDelegate: AnyObject {
    func didEditProfile()
}
/// добавить изображение
protocol ProfileAddPhotoDelegate: AnyObject {
    func didAddPhoto()
}
/// подробная информация
protocol ProfileFurtherInformationDelegate: AnyObject {
    func didFurtherInformation()
}
/// Отображает вью шапки профиля
class ProfileTableHeaderView: UIView {
    
    
    // MARK: - UI
    /// изображение - аватар
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "header1")
        imageView.layer.cornerRadius = 55
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    /// кнопка редактировать
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "Orange")
        button.setTitle("Редактировать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SF Mono", size: 24)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(self.buttonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.isHidden = false
        button.layer.masksToBounds = false
        return button
    }()
    /// кнопка подписаться
    private lazy var followButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SF Mono", size: 24)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(self.buttonFollow), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.isHidden = true
        button.layer.masksToBounds = false
        return button
    }()
    
    /// имя пользователя
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "Black")
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /// статус
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "дизайнер"
        label.textAlignment = .left
        label.font = UIFont(name: "Arial", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /// иконка около подробной информации
    private lazy var detailsIcon: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "exclamationmark.lock.fill")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(named: "Orange")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    /// лейбл подробная информация
    private lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.text = "Подробная информация"
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = UIColor(named: "Black")
        label.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addFurtherInformation))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    /// количество подписчиков
    private lazy var followers: UILabel = {
        let label = UILabel()
        label.text = "161 тыс. подписчиков"
        label.font = UIFont(name: "Arial", size: 15)
        label.textColor = UIColor(named: "Black")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /// количество подписок
    private lazy var following: UILabel = {
        let label = UILabel()
        label.text = "477 подписок"
        label.font = UIFont(name: "Arial", size: 15)
        label.textColor = UIColor(named: "Black")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /// количество публикаций
    private lazy var photosPublished: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial", size: 15)
        label.textColor = UIColor(named: "Black")
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /// линия разделения
    private let lineView = LineView()
    /// кнопка сделать запись
    private lazy var buttonSquare: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor(named: "Black")
        button.addTarget(self, action: #selector(self.buttonTapSquare), for: .touchUpInside)
        let image = UIImage(systemName: "square.and.pencil")
        button.setImage(image, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.isHidden = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    /// кнопка записать историю
    private lazy var buttonCamera: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor(named: "Black")
        button.addTarget(self, action: #selector(self.buttonTapCamera), for: .touchUpInside)
        let image = UIImage(systemName: "camera")
        button.setImage(image, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.isHidden = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    /// кнопка добавить изображение
    private lazy var buttonPhoto: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor(named: "Black")
        button.addTarget(self, action: #selector(self.buttonTapPhoto), for: .touchUpInside)
        let image = UIImage(systemName: "photo")
        button.setImage(image, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.isHidden = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    /// лейбл запись
    private lazy var squareLabel: UILabel = {
        let label = UILabel()
        label.text = "Запись"
        label.font = UIFont(name: "Arial", size: 15)
        label.textColor = UIColor(named: "Black")
        label.isHidden = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /// лейбл история
    private lazy var cameraLabel: UILabel = {
        let label = UILabel()
        label.text = "История"
        label.font = UIFont(name: "Arial", size: 15)
        label.textColor = UIColor(named: "Black")
        label.isHidden = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /// лейбл фото
    private lazy var photoLabel: UILabel = {
        let label = UILabel()
        label.text = "Фото"
        label.font = UIFont(name: "Arial", size: 15)
        label.textColor = UIColor(named: "Black")
        label.isHidden = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // MARK: - Properties
    weak var delegate: ProfileTableHeaderAddPostViewDelegate?
    weak var cameraDelegate: ProfileCameraDelegate?
    weak var editProfileDelegate: ProfileEditDelegate?
    weak var addPhotoDelegate: ProfileAddPhotoDelegate?
    weak var furtherInformation: ProfileFurtherInformationDelegate?
    var isAnotherUser = false
    var isButtonFollowTapped = false {
        didSet {
            if isButtonFollowTapped {
                followButton.setTitle("Подписаться", for: .normal)
                followButton.backgroundColor = UIColor(named: "Orange")
            } else {
                followButton.setTitle("Убрать подписку", for: .normal)
                followButton.backgroundColor = UIColor(named: "Gray")
            }
        }
    }
    
    // MARK:  - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupView()
        constraints()
        followButton.setTitle("Подписаться", for: .normal)
        followButton.backgroundColor = UIColor(named: "Orange")
        lineView.isHidden = false
        if isAnotherUser == true {
            editButton.isHidden = true
            followButton.isHidden = false
            lineView.isHidden = true
            squareLabel.isHidden = true
            photoLabel.isHidden = true
            cameraLabel.isHidden = true
            buttonCamera.isHidden = true
            buttonSquare.isHidden = true
            buttonPhoto.isHidden = true
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    private func setupView() {
        addSubview(avatarImageView)
        addSubview(editButton)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(detailsIcon)
        addSubview(detailsLabel)
        addSubview(photosPublished)
        addSubview(following)
        addSubview(followers)
        addSubview(lineView)
        addSubview(buttonSquare)
        addSubview(buttonCamera)
        addSubview(buttonPhoto)
        addSubview(squareLabel)
        addSubview(cameraLabel)
        addSubview(photoLabel)
        addSubview(followButton)
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            /// изображение - аватар
            avatarImageView.topAnchor.constraint(equalTo: self.topAnchor,constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 110),
            avatarImageView.heightAnchor.constraint(equalToConstant: 110),
            /// кнопка редактировать
            editButton.topAnchor.constraint(equalTo: self.avatarImageView.bottomAnchor,constant: 25),
            editButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            editButton.heightAnchor.constraint(equalToConstant: 50),
            editButton.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -16),
            /// кнопка подписаться
            followButton.topAnchor.constraint(equalTo: self.avatarImageView.bottomAnchor,constant: 25),
            followButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            followButton.heightAnchor.constraint(equalToConstant: 50),
            followButton.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -16),
            /// имя пользователя
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor,constant: 35),
            nameLabel.leadingAnchor.constraint(equalTo: self.avatarImageView.trailingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            /// статус
            descriptionLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor,constant: 5 ),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.avatarImageView.trailingAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 20),
            /// иконка подробная инфомация
            detailsIcon.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 10),
            detailsIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 130),
            detailsIcon.widthAnchor.constraint(equalToConstant: 25),
            detailsIcon.heightAnchor.constraint(equalToConstant: 25),
            /// лейбл подробная информация
            detailsLabel.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 11),
            detailsLabel.leadingAnchor.constraint(equalTo: self.detailsIcon.trailingAnchor, constant: 0),
            detailsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            detailsLabel.heightAnchor.constraint(equalToConstant: 25),
            /// количество публикаций
            photosPublished.topAnchor.constraint(equalTo: self.editButton.bottomAnchor, constant: 25),
            photosPublished.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            photosPublished.heightAnchor.constraint(equalToConstant: 50),
            photosPublished.widthAnchor.constraint(equalToConstant: 85),
            /// количество подписок
            following.topAnchor.constraint(equalTo:self.editButton.bottomAnchor, constant: 25),
            following.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            following.heightAnchor.constraint(equalToConstant: 50),
            following.widthAnchor.constraint(equalToConstant: 85),
            /// количество подписчиков
            followers.topAnchor.constraint(equalTo:self.editButton.bottomAnchor, constant: 25),
            followers.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            followers.heightAnchor.constraint(equalToConstant: 50),
            followers.widthAnchor.constraint(equalToConstant: 90),
            /// линия разделения
            lineView.topAnchor.constraint(equalTo: self.photosPublished.bottomAnchor, constant: 15),
            lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
            /// кнопка сделать пост
            buttonSquare.topAnchor.constraint(equalTo: self.lineView.bottomAnchor, constant: 15),
            buttonSquare.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 52),
            buttonSquare.widthAnchor.constraint(equalToConstant: 35),
            buttonSquare.heightAnchor.constraint(equalToConstant: 35),
            /// кнопка сделать историю
            buttonCamera.topAnchor.constraint(equalTo: self.lineView.bottomAnchor, constant: 17),
            buttonCamera.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            buttonCamera.widthAnchor.constraint(equalToConstant: 40),
            buttonCamera.heightAnchor.constraint(equalToConstant: 35),
            /// кнопка сделать фото
            buttonPhoto.topAnchor.constraint(equalTo: self.lineView.bottomAnchor, constant: 16),
            buttonPhoto.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -55),
            buttonPhoto.widthAnchor.constraint(equalToConstant: 40),
            buttonPhoto.heightAnchor.constraint(equalToConstant: 35),
            /// лейбл запись
            squareLabel.topAnchor.constraint(equalTo: self.buttonSquare.bottomAnchor, constant: 10),
            squareLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 45),
            squareLabel.widthAnchor.constraint(equalToConstant: 50),
            squareLabel.heightAnchor.constraint(equalToConstant: 20),
            /// лейбл истрия
            cameraLabel.topAnchor.constraint(equalTo: self.buttonCamera.bottomAnchor, constant: 8),
            cameraLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cameraLabel.widthAnchor.constraint(equalToConstant: 60),
            cameraLabel.heightAnchor.constraint(equalToConstant: 20),
            /// лейбл фото
            photoLabel.topAnchor.constraint(equalTo: self.buttonPhoto.bottomAnchor, constant: 10),
            photoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -58),
            photoLabel.widthAnchor.constraint(equalToConstant: 35),
            photoLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    /// редактировать профиль
    @objc private func buttonPressed() {
        editProfileDelegate?.didEditProfile()
    }
    /// сделать запись - пост
    @objc private func buttonTapSquare() {
        delegate?.didTapCreatePost()
    }
    /// сделать историю
    @objc private func buttonTapCamera() {
        cameraDelegate?.didTapCamera()
    }
    /// добавить фото
    @objc private func buttonTapPhoto() {
        addPhotoDelegate?.didAddPhoto()
    }
    /// посмотреть подробную информацию
    @objc private func addFurtherInformation() {
        furtherInformation?.didFurtherInformation()
    }
    /// количество публикаций
    func updatePhotosPublished(count: Int) {
        photosPublished.text = "\(count) публикаций"
    }
    ///  подписаться
    @objc private func buttonFollow() {
        isButtonFollowTapped.toggle()
    }
}
