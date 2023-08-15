//
//  CommentTableViewCell.swift
//  VK
//
//  Created by Эля Корельская on 15.08.2023.
//

import UIKit
/// комментарии
class CommentTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "CommentTableViewCell"
    
    
    // MARK: - UI
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        backgroundColor = .secondarySystemBackground
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(avatarImageView)
        contentView.addSubview(commentLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(userLabel)

    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        commentLabel.sizeToFit()
        dateLabel.sizeToFit()
        constraints()
    }
    private func constraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            avatarImageView.widthAnchor.constraint(equalToConstant: 24),
            avatarImageView.heightAnchor.constraint(equalToConstant: 24),
            
            userLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            userLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 5),
            userLabel.widthAnchor.constraint(equalToConstant: 100),
            userLabel.heightAnchor.constraint(equalToConstant: 20),
            
            commentLabel.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 10),
            commentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            commentLabel.widthAnchor.constraint(equalToConstant: 250),
            commentLabel.heightAnchor.constraint(equalToConstant: 20),
            
            dateLabel.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateLabel.widthAnchor.constraint(equalToConstant: 150),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
    
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = nil
        commentLabel.text = nil
        avatarImageView.image = nil
    }
    // MARK: - Methods
    public func configure(with model: PostComment) {
        userLabel.text = model.user.identifier
        commentLabel.text = model.text
        dateLabel.text = .date(with: model.date)
        avatarImageView.image = model.user.profilePicture
    }
}

