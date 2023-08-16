//
//  ProfileTableHeaderView.swift
//  VK
//
//  Created by Эля Корельская on 29.07.2023.
//

import UIKit
protocol ProfileTableHeaderViewDelegate: AnyObject {
    func didTapCreatePost()
}
protocol ProfileCameraDelegate: AnyObject {
    func didTapCamera()
}
protocol ProfileEditDelegate: AnyObject {
    func didEditProfile()
}
protocol ProfileAddPhotoDelegate: AnyObject {
    func didAddPhoto()
}
protocol ProfileFurtherInformationDelegate: AnyObject {
    func didFurtherInformation()
}

class ProfileTableHeaderView: UIView {
    
    
    // MARK: - UI
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "header1")
        imageView.layer.cornerRadius = 55
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "Orange")
        button.setTitle("Редактировать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SF Mono", size: 24)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(self.buttonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = false
        return button
    }()
    // username
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "Black")
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // status
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "дизайнер"
        label.textAlignment = .left
        label.font = UIFont(name: "Arial", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var detailsIcon: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "exclamationmark.lock.fill")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(named: "Orange")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var detailsLabel: UILabel = {
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
    
    private lazy var photosPublished: UILabel = {
        let label = UILabel()
        label.text = "1400 публикаций"
        label.font = UIFont(name: "Arial", size: 15)
        label.textColor = UIColor(named: "Black")
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let lineView = LineView()
    
    lazy var buttonSquare: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor(named: "Black")
        button.addTarget(self, action: #selector(self.buttonTapSquare), for: .touchUpInside)
        let image = UIImage(systemName: "square.and.pencil")
        button.setImage(image, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var buttonCamera: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor(named: "Black")
        button.addTarget(self, action: #selector(self.buttonTapCamera), for: .touchUpInside)
        let image = UIImage(systemName: "camera")
        button.setImage(image, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var buttonPhoto: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor(named: "Black")
        button.addTarget(self, action: #selector(self.buttonTapPhoto), for: .touchUpInside)
        let image = UIImage(systemName: "photo")
        button.setImage(image, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var squareLabel: UILabel = {
        let label = UILabel()
        label.text = "Запись"
        label.font = UIFont(name: "Arial", size: 15)
        label.textColor = UIColor(named: "Black")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var cameraLabel: UILabel = {
        let label = UILabel()
        label.text = "История"
        label.font = UIFont(name: "Arial", size: 15)
        label.textColor = UIColor(named: "Black")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var photoLabel: UILabel = {
        let label = UILabel()
        label.text = "Фото"
        label.font = UIFont(name: "Arial", size: 15)
        label.textColor = UIColor(named: "Black")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // MARK: - Properties
    weak var delegate: ProfileTableHeaderViewDelegate?
    weak var cameraDelegate: ProfileCameraDelegate?
    weak var editProfileDelegate: ProfileEditDelegate?
    weak var addPhotoDelegate: ProfileAddPhotoDelegate?
    weak var furtherInformation: ProfileFurtherInformationDelegate?
    
    // MARK:  - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupView()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    private func setupView() {
        addSubview(avatarImageView)
        addSubview(button)
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
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            // image avatar
            avatarImageView.topAnchor.constraint(equalTo: self.topAnchor,constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 110),
            avatarImageView.heightAnchor.constraint(equalToConstant: 110),
            // редактировать button
            button.topAnchor.constraint(equalTo: self.avatarImageView.bottomAnchor,constant: 25),
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -16),
            // username
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor,constant: 35),
            nameLabel.leadingAnchor.constraint(equalTo: self.avatarImageView.trailingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            // status
            descriptionLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor,constant: 5 ),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.avatarImageView.trailingAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 20),
            // icon details
            detailsIcon.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 10),
            detailsIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 130),
            detailsIcon.widthAnchor.constraint(equalToConstant: 25),
            detailsIcon.heightAnchor.constraint(equalToConstant: 25),
            // details label
            detailsLabel.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 11),
            detailsLabel.leadingAnchor.constraint(equalTo: self.detailsIcon.trailingAnchor, constant: 0),
            detailsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            detailsLabel.heightAnchor.constraint(equalToConstant: 25),
            // published photos
            photosPublished.topAnchor.constraint(equalTo: self.button.bottomAnchor, constant: 25),
            photosPublished.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            photosPublished.heightAnchor.constraint(equalToConstant: 50),
            photosPublished.widthAnchor.constraint(equalToConstant: 85),
            // following
            following.topAnchor.constraint(equalTo:self.button.bottomAnchor, constant: 25),
            following.leadingAnchor.constraint(equalTo: self.photosPublished.trailingAnchor, constant: 40),
            following.heightAnchor.constraint(equalToConstant: 50),
            following.widthAnchor.constraint(equalToConstant: 85),
            // followers
            followers.topAnchor.constraint(equalTo:self.button.bottomAnchor, constant: 25),
            followers.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            followers.heightAnchor.constraint(equalToConstant: 50),
            followers.widthAnchor.constraint(equalToConstant: 90),
            // lineView
            lineView.topAnchor.constraint(equalTo: self.photosPublished.bottomAnchor, constant: 15),
            lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
            // button square
            buttonSquare.topAnchor.constraint(equalTo: self.lineView.bottomAnchor, constant: 15),
            buttonSquare.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 52),
            buttonSquare.widthAnchor.constraint(equalToConstant: 35),
            buttonSquare.heightAnchor.constraint(equalToConstant: 35),
            // button camera
            buttonCamera.topAnchor.constraint(equalTo: self.lineView.bottomAnchor, constant: 17),
            buttonCamera.trailingAnchor.constraint(equalTo: self.buttonSquare.trailingAnchor, constant: 130),
            buttonCamera.widthAnchor.constraint(equalToConstant: 40),
            buttonCamera.heightAnchor.constraint(equalToConstant: 35),
            // button photo
            buttonPhoto.topAnchor.constraint(equalTo: self.lineView.bottomAnchor, constant: 16),
            buttonPhoto.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -55),
            buttonPhoto.widthAnchor.constraint(equalToConstant: 40),
            buttonPhoto.heightAnchor.constraint(equalToConstant: 35),
            // square label
            squareLabel.topAnchor.constraint(equalTo: self.buttonSquare.bottomAnchor, constant: 10),
            squareLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 45),
            squareLabel.widthAnchor.constraint(equalToConstant: 50),
            squareLabel.heightAnchor.constraint(equalToConstant: 20),
            // camera label
            cameraLabel.topAnchor.constraint(equalTo: self.buttonCamera.bottomAnchor, constant: 8),
            cameraLabel.leadingAnchor.constraint(equalTo: self.squareLabel.trailingAnchor, constant: 73),
            cameraLabel.widthAnchor.constraint(equalToConstant: 60),
            cameraLabel.heightAnchor.constraint(equalToConstant: 20),
            // photo label
            photoLabel.topAnchor.constraint(equalTo: self.buttonPhoto.bottomAnchor, constant: 10),
            photoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -58),
            photoLabel.widthAnchor.constraint(equalToConstant: 35),
            photoLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    @objc private func buttonPressed() {
        editProfileDelegate?.didEditProfile()
    }
    @objc private func buttonTapSquare() {
        delegate?.didTapCreatePost()
    }
    @objc private func buttonTapCamera() {
        cameraDelegate?.didTapCamera()
    }
    @objc private func buttonTapPhoto() {
        addPhotoDelegate?.didAddPhoto()
    }
    @objc private func addFurtherInformation() {
        furtherInformation?.didFurtherInformation()
    }
}
