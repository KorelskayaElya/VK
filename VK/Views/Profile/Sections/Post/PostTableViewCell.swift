//
//  PostTableViewCell.swift
//  VK
//
//  Created by Эля Корельская on 07.08.2023.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
   
    private var isFullTextShown = false
    
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
    private lazy var detailsIcon: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "info.circle.fill")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(named: "Orange")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var likeIcon: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "heart")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(named: "Orange")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
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
    
    private let lineView = LineVerticalView()
    private let lineViewGorizontal = LineView()
   
    private lazy var textPostLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "Black")
        label.text = "With prototyping in Figma, you can create multiple flows for your prototype in one page to preview a user's full journey and experience through your designs. A flow is a path users take through the network of connected frames that make up your prototype. For example, you can create a prototype for a shopping app that includes a flow for account creation, another for browsing items, and another for the checkout process–all in one page.When you add a connection between two frames with no existing connections in your prototype, a flow starting point is created. You can create multiple flows using the same network of connected frames by adding different flow starting points."
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont(name: "Arial", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var fullbutton: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.text = "Показать полностью..."
        label.textAlignment = .left
        label.font = UIFont(name: "Arial", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showFullText))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        
        return label
    }()

    @objc private func showFullText() {
        isFullTextShown.toggle()
        updateTextPostLabel()
    }
    private func updateTextPostLabel() {
        if isFullTextShown {
            textPostLabel.text = "With prototyping in Figma, you can create multiple flows for your prototype in one page to preview a user's full journey and experience through your designs. A flow is a path users take through the network of connected frames that make up your prototype. For example, you can create a prototype for a shopping app that includes a flow for account creation, another for browsing items, and another for the checkout process–all in one page.When you add a connection between two frames with no existing connections in your prototype, a flow starting point is created. You can create multiple flows using the same network of connected frames by adding different flow starting points."
        } else {
            let shortText = "With prototyping in Figma, you can create multiple flows for your prototype in one page to preview a user's full journey and experience through your designs. A flow is a path users take through the network of connected frames that make up your prototype."
            textPostLabel.text = shortText
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        lineViewGorizontal.tintColor = .lightGray
        contentView.addSubview(postImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(detailsIcon)
        contentView.addSubview(lineView)
        contentView.addSubview(textPostLabel)
        contentView.addSubview(fullbutton)
        contentView.addSubview(lineViewGorizontal)
        contentView.addSubview(likeIcon)
        contentView.addSubview(likeCountLabel)
        contentView.addSubview(CommentIcon)
        contentView.addSubview(CommentCountLabel)
        contentView.addSubview(BookmarkIcon)
        
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            nameLabel.widthAnchor.constraint(equalToConstant: 180),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 80),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 20),
            
            detailsIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            detailsIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            detailsIcon.widthAnchor.constraint(equalToConstant: 45),
            detailsIcon.heightAnchor.constraint(equalToConstant: 45),
            
            lineView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 75),
            lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            lineView.heightAnchor.constraint(equalToConstant: 5),
            lineView.bottomAnchor.constraint(equalTo: lineViewGorizontal.topAnchor, constant: -20),

            
            textPostLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            textPostLabel.leadingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: 10),
            textPostLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            textPostLabel.heightAnchor.constraint(equalToConstant: 100),
            
            
            postImageView.topAnchor.constraint(equalTo: fullbutton.bottomAnchor, constant: 5),
            postImageView.leadingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: 10),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            postImageView.bottomAnchor.constraint(equalTo: lineViewGorizontal.topAnchor, constant: -30),
        
            
            fullbutton.topAnchor.constraint(equalTo: textPostLabel.bottomAnchor, constant: 1),
            fullbutton.leadingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: 10),
            fullbutton.widthAnchor.constraint(equalToConstant: 180),
            fullbutton.heightAnchor.constraint(equalToConstant: 20),
            
            lineViewGorizontal.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            lineViewGorizontal.heightAnchor.constraint(equalToConstant: 1),
            lineViewGorizontal.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lineViewGorizontal.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60),
            
            likeIcon.topAnchor.constraint(equalTo: lineViewGorizontal.bottomAnchor, constant: 3),
            likeIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 45),
            likeIcon.widthAnchor.constraint(equalToConstant: 45),
            likeIcon.heightAnchor.constraint(equalToConstant: 45),
            
            likeCountLabel.topAnchor.constraint(equalTo: lineViewGorizontal.bottomAnchor, constant: 15),
            likeCountLabel.leadingAnchor.constraint(equalTo: likeIcon.trailingAnchor),
            likeCountLabel.widthAnchor.constraint(equalToConstant: 45),
            likeCountLabel.heightAnchor.constraint(equalToConstant: 20),
            
            CommentIcon.topAnchor.constraint(equalTo: lineViewGorizontal.bottomAnchor, constant: 5),
            CommentIcon.leadingAnchor.constraint(equalTo: likeCountLabel.trailingAnchor, constant: 20),
            CommentIcon.widthAnchor.constraint(equalToConstant: 45),
            CommentIcon.heightAnchor.constraint(equalToConstant: 45),
            
            CommentCountLabel.topAnchor.constraint(equalTo: lineViewGorizontal.bottomAnchor, constant: 15),
            CommentCountLabel.leadingAnchor.constraint(equalTo: CommentIcon.trailingAnchor),
            CommentCountLabel.widthAnchor.constraint(equalToConstant: 45),
            CommentCountLabel.heightAnchor.constraint(equalToConstant: 20),
            
            BookmarkIcon.topAnchor.constraint(equalTo: lineViewGorizontal.bottomAnchor, constant: 5),
            BookmarkIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            BookmarkIcon.widthAnchor.constraint(equalToConstant: 45),
            BookmarkIcon.heightAnchor.constraint(equalToConstant: 45),
            
            
            
        ])
    }
    
    func configure(with image: UIImage?, user: User) {
        postImageView.image = image
        avatarImageView.image = user.profilePicture 
        descriptionLabel.text = user.status
        nameLabel.text = user.username
        
    }
}

