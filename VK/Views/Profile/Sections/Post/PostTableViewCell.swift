//
//  PostTableViewCell.swift
//  VK
//
//  Created by Эля Корельская on 07.08.2023.
//

import UIKit

protocol PostTableViewCellLikeDelegate: AnyObject {
    func postTableViewCellDidTapLikeSaveWith(_ post: PostEntity)
}
protocol PostTableViewCellSaveDelegate: AnyObject {
    func postTableViewCellDidTapSavePostWith(_ post: PostEntity)
}

/// структура поста
class PostTableViewCell: UITableViewCell {
   
    // MARK: - UI
    /// изображение аватара
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
   /// отображение имени  фамилии пользователя
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "Black")
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /// отображение статуса пользователя
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont(name: "Arial", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /// иконка лайка
    private lazy var likeIconButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "heart.fill")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(named: "Orange")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        return button
    }()
    /// отображение времени публикации поста
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    /// иконка закладки
    private lazy var bookmarkIconButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "bookmark.fill")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(named: "Orange")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        return button
    }()
    /// изображение поста
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
   /// отображение текста поста
    private lazy var textPostLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "Black")
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont(name: "Arial", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /// линии для декорации времени
    private let lineView = LineView()
    private let lineView2 = LineView()
    private var textPostLabelHeightConstraint: NSLayoutConstraint!
    private var postImageViewHeightConstraint: NSLayoutConstraint!
   
    // MARK: - Properties
    weak var delegate: PostTableViewCellLikeDelegate?
    weak var saveDelegate: PostTableViewCellSaveDelegate?
    private var post: PostEntity?
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Interface
    func configure(with post: PostEntity, textFont: UIFont, contentWidth: CGFloat) {
        if let profilePictureData = post.profilePicture {
            avatarImageView.image = UIImage(data: profilePictureData)
        }
        
        descriptionLabel.text = post.status
        nameLabel.text = post.username
        timeLabel.text = String.date(with: Date())
        
        textPostLabel.text = post.textPost
        let textHeight = calculateTextHeight(text: post.textPost ?? "", font: textFont, width: contentWidth)
        textPostLabelHeightConstraint.constant = textHeight + 30
        postImageView.image = nil
        if let imagePostData = post.imagePost {
            postImageView.image = UIImage(data: imagePostData)
            let imageHeight = calculateImageHeight(image: postImageView.image, width: contentWidth)
            postImageViewHeightConstraint.constant = imageHeight
        }
        
        likeIconButton.tintColor = post.isLikedByCurrentUser ? .systemRed : .systemOrange
        bookmarkIconButton.tintColor = post.isSavedByCurrentUser ? .systemGray : .systemOrange
        
        self.post = post
    }

    // MARK: - Private
    private func setupView() {
        lineView.tintColor = .lightGray
        lineView2.tintColor = .lightGray
        contentView.addSubview(postImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(lineView)
        contentView.addSubview(textPostLabel)
        contentView.addSubview(likeIconButton)
        contentView.addSubview(bookmarkIconButton)
        contentView.addSubview(timeLabel)
        contentView.addSubview(lineView2)
        
        textPostLabelHeightConstraint = textPostLabel.heightAnchor.constraint(equalToConstant: 0)
        textPostLabelHeightConstraint.priority = .defaultHigh

        postImageViewHeightConstraint = postImageView.heightAnchor.constraint(equalToConstant: 0)
        postImageViewHeightConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 5),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            nameLabel.widthAnchor.constraint(equalToConstant: 180),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 80),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 20),
            
            lineView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            lineView.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor),
            
            lineView2.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            lineView2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            lineView2.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor),

            
            textPostLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            textPostLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            textPostLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            textPostLabelHeightConstraint,
            
            
            postImageView.topAnchor.constraint(equalTo: textPostLabel.bottomAnchor),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            postImageViewHeightConstraint,
            
            likeIconButton.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 5),
            likeIconButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            likeIconButton.widthAnchor.constraint(equalToConstant: 55),
            likeIconButton.heightAnchor.constraint(equalToConstant: 55),
            
            bookmarkIconButton.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 10),
            bookmarkIconButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            bookmarkIconButton.widthAnchor.constraint(equalToConstant: 45),
            bookmarkIconButton.heightAnchor.constraint(equalToConstant: 45),
            
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor , constant: 10),
            timeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: 100),
            timeLabel.heightAnchor.constraint(equalToConstant: 20),
            
        ])
    }
    /// добавлять в лайки
    @objc private func didTapLike() {
        guard let post = post else {return}
        delegate?.postTableViewCellDidTapLikeSaveWith(post)
    }
    /// добавлять в закладки
    @objc private func didTapSave() {
        guard let post = post else {return}
        saveDelegate?.postTableViewCellDidTapSavePostWith(post)
    }

    /// рассчет высоты текста
    func calculateTextHeight(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin], attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    /// рассчет высоты изображения
    func calculateImageHeight(image: UIImage?, width: CGFloat) -> CGFloat {
        guard let image = image else {
            return 0
        }
        let aspectRatio = image.size.height / image.size.width
        return width * aspectRatio
    }
    /// рассчет размеров текста и изображения
    func updateConstraints(for post: Post, textFont: UIFont, contentWidth: CGFloat) {
        let textHeight = calculateTextHeight(text: post.textPost, font: textFont, width: contentWidth)
        textPostLabelHeightConstraint.constant = textHeight
        
        let imageHeight = calculateImageHeight(image: post.imagePost, width: contentWidth)
        postImageViewHeightConstraint.constant = imageHeight
        
        layoutIfNeeded()
    }


}

