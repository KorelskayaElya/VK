//
//  PostTableViewCell.swift
//  VK
//
//  Created by Эля Корельская on 07.08.2023.
//

import UIKit

protocol PostTableViewCellDelegate: AnyObject {
    func postTableViewCellDidTapLike(_ cell: PostTableViewCell)
}


class PostTableViewCell: UITableViewCell {
    
    weak var delegate: PostTableViewCellDelegate?
    private var isFullTextShown = false
    
//    var model: Post
//
//    init(model: Post, reuseIdentifier: String?) {
//        self.model = model
//        super.init(style: .default, reuseIdentifier: reuseIdentifier)
//        setupView()
//    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "Black")
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // status
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont(name: "Arial", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var likeIcon: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "heart")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(named: "Orange")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        return button
    }()
    @objc private func didTapLike() {
        //model.isLikedByCurrentUser = !model.isLikedByCurrentUser
        //likeIcon.tintColor = model.isLikedByCurrentUser ? .systemRed : UIColor(named: "Orange")
        delegate?.postTableViewCellDidTapLike(self)
    }

    private lazy var likeCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "Black")
        label.text = "40"
        label.textAlignment = .left
        label.font = UIFont(name: "Arial", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var CommentCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "Black")
        label.text = "40"
        label.textAlignment = .left
        label.font = UIFont(name: "Arial", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        let currentDate = Date()
        let formattedDate = String.date(with: currentDate)
        label.text = formattedDate
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    private lazy var CommentIcon: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "text.bubble")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(named: "Orange")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var BookmarkIcon: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "bookmark")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(named: "Orange")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let lineView = LineView()
    private let lineView2 = LineView()
   
    private lazy var textPostLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "Black")
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont(name: "Arial", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
//    private lazy var fullbutton: UILabel = {
//        let label = UILabel()
//        label.textColor = .blue
//        label.text = "Показать полностью..."
//        label.textAlignment = .left
//        label.font = UIFont(name: "Arial", size: 14)
//        label.translatesAutoresizingMaskIntoConstraints = false
//
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showFullText))
//        label.isUserInteractionEnabled = true
//        label.addGestureRecognizer(tapGesture)
//
//        return label
//    }()

    @objc private func showFullText() {
        isFullTextShown.toggle()
    }
    
    private func setupView() {
        lineView.tintColor = .lightGray
        lineView2.tintColor = .lightGray
        contentView.addSubview(postImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(lineView)
        contentView.addSubview(textPostLabel)
        //contentView.addSubview(fullbutton)
        contentView.addSubview(likeIcon)
        contentView.addSubview(likeCountLabel)
        contentView.addSubview(CommentIcon)
        contentView.addSubview(CommentCountLabel)
        contentView.addSubview(BookmarkIcon)
        contentView.addSubview(timeLabel)
        contentView.addSubview(lineView2)
        
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

            
            textPostLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            textPostLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            textPostLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            textPostLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            
            postImageView.topAnchor.constraint(equalTo: textPostLabel.bottomAnchor),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            postImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -55),
        
            
//            fullbutton.topAnchor.constraint(equalTo: textPostLabel.bottomAnchor, constant: 1),
//            fullbutton.leadingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: 10),
//            fullbutton.widthAnchor.constraint(equalToConstant: 180),
//            fullbutton.heightAnchor.constraint(equalToConstant: 20),
            
            likeIcon.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 10),
            likeIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 45),
            likeIcon.widthAnchor.constraint(equalToConstant: 45),
            likeIcon.heightAnchor.constraint(equalToConstant: 45),
            
            likeCountLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 23),
            likeCountLabel.leadingAnchor.constraint(equalTo: likeIcon.trailingAnchor),
            likeCountLabel.widthAnchor.constraint(equalToConstant: 45),
            likeCountLabel.heightAnchor.constraint(equalToConstant: 20),
            
            CommentIcon.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 13),
            CommentIcon.leadingAnchor.constraint(equalTo: likeCountLabel.trailingAnchor, constant: 20),
            CommentIcon.widthAnchor.constraint(equalToConstant: 40),
            CommentIcon.heightAnchor.constraint(equalToConstant: 40),
            
            CommentCountLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 22),
            CommentCountLabel.leadingAnchor.constraint(equalTo: CommentIcon.trailingAnchor),
            CommentCountLabel.widthAnchor.constraint(equalToConstant: 45),
            CommentCountLabel.heightAnchor.constraint(equalToConstant: 20),
            
            BookmarkIcon.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 10),
            BookmarkIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            BookmarkIcon.widthAnchor.constraint(equalToConstant: 45),
            BookmarkIcon.heightAnchor.constraint(equalToConstant: 45),
            
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor , constant: 10),
            timeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: 100),
            timeLabel.heightAnchor.constraint(equalToConstant: 20),
            
        ])
    }
    
    func configure(with post: Post) {
        postImageView.image = post.imagePost
        avatarImageView.image = post.user.profilePicture
        descriptionLabel.text = post.user.status
        nameLabel.text = post.user.username
        textPostLabel.text = post.textPost
    }
}

