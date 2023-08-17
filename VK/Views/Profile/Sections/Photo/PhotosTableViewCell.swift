//
//  PhotosTableViewCell.swift
//  VK
//
//  Created by Эля Корельская on 03.08.2023.
//

import UIKit

protocol ProfileTableViewCellDelegate {
    func didTapButton(sender: UIButton)
}
// структура изображений в профиле в коллекции
class PhotosTableViewCell: UITableViewCell {

    // MARK: - UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "Black")
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var countPhotosLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var button_photos: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "next"), for: .normal)
        button.contentMode = .scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.didTapButton), for: .touchUpInside)
        button.tintColor = .black
        return button
    }()
    private lazy var stackWithPersons: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.clipsToBounds = true
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var Image1: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    private lazy var Image2: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    private lazy var Image3: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    private lazy var Image4: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    private lazy var Image5: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    // MARK: - Properties
    var delegate: ProfileTableViewCellDelegate?
    
    struct ViewModel {
        let title: String
        let image: UIImage?
    }
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }

   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Private
    private func setupView() {
        self.contentView.addSubview(self.stackWithPersons)
        self.addSubview(self.titleLabel)
        self.addSubview(self.countPhotosLabel)
        self.stackWithPersons.addArrangedSubview(self.Image1)
        self.stackWithPersons.addArrangedSubview(self.Image2)
        self.stackWithPersons.addArrangedSubview(self.Image3)
        self.stackWithPersons.addArrangedSubview(self.Image4)
        self.stackWithPersons.addArrangedSubview(self.Image5)
        self.addSubview(self.button_photos)
        NSLayoutConstraint.activate([
            
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            self.titleLabel.widthAnchor.constraint(equalToConstant: 110),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            self.countPhotosLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            self.countPhotosLabel.leadingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: 10),
            self.countPhotosLabel.widthAnchor.constraint(equalToConstant: 60),
            self.countPhotosLabel.heightAnchor.constraint(equalToConstant: 20),

            self.stackWithPersons.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 12),
            self.stackWithPersons.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),
            self.stackWithPersons.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
            self.stackWithPersons.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12),

            self.button_photos.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            self.button_photos.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            self.button_photos.widthAnchor.constraint(equalToConstant: 15),
            self.button_photos.heightAnchor.constraint(equalToConstant: 15),

        

        ])
    }
    @objc private func didTapButton() {
        delegate?.didTapButton(sender: button_photos)
    }
    func setup(with viewModel: ViewModel) {
        self.titleLabel.text = "Photos".localized
        self.countPhotosLabel.text = "10"
        self.Image1.image = UIImage(named: "picture1")
        self.Image2.image = UIImage(named: "picture2")
        self.Image3.image = UIImage(named: "picture3")
        self.Image4.image = UIImage(named: "picture4")
        self.Image5.image = UIImage(named: "picture5")
    }
    
}


