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
/// структура изображений в профиле в коллекции
class PhotosTableViewCell: UITableViewCell {

    // MARK: - UI
    /// фотографии
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "Black")
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /// количество изображений
    private lazy var countPhotosLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /// кнопка перехода на все  изображения
    private lazy var button_photos: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "next"), for: .normal)
        button.contentMode = .scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.didTapButton), for: .touchUpInside)
        button.tintColor = UIColor.createColor(lightMode: .black, darkMode: .white)
        return button
    }()
    /// стек для изображений
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
    /// 1 фото
    private lazy var Image1: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    /// 2 фото
    private lazy var Image2: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    /// 3 фото
    private lazy var Image3: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    /// 4 фото
    private lazy var Image4: UIImageView = {
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
        contentView.addSubview(stackWithPersons)
        addSubview(titleLabel)
        addSubview(countPhotosLabel)
        stackWithPersons.addArrangedSubview(Image1)
        stackWithPersons.addArrangedSubview(Image2)
        stackWithPersons.addArrangedSubview(Image3)
        stackWithPersons.addArrangedSubview(Image4)
        addSubview(button_photos)
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.widthAnchor.constraint(equalToConstant: 110),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            countPhotosLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            countPhotosLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            countPhotosLabel.widthAnchor.constraint(equalToConstant: 60),
            countPhotosLabel.heightAnchor.constraint(equalToConstant: 20),

            stackWithPersons.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            stackWithPersons.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stackWithPersons.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            stackWithPersons.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            Image1.widthAnchor.constraint(equalTo: stackWithPersons.widthAnchor, multiplier: 0.234),
            Image2.widthAnchor.constraint(equalTo: stackWithPersons.widthAnchor, multiplier: 0.234),
            Image3.widthAnchor.constraint(equalTo: stackWithPersons.widthAnchor, multiplier: 0.234),
            Image4.widthAnchor.constraint(equalTo: stackWithPersons.widthAnchor, multiplier: 0.234),

            button_photos.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            button_photos.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            button_photos.widthAnchor.constraint(equalToConstant: 15),
            button_photos.heightAnchor.constraint(equalToConstant: 15),

        

        ])
    }
    /// переход на все фотографии
    @objc private func didTapButton() {
        delegate?.didTapButton(sender: button_photos)
    }
    /// установить изображения из всех фотографий в профиль
    func setup(with viewModel: ViewModel) {
        titleLabel.text = "Photos".localized
        countPhotosLabel.text = "\(CoreDataService.shared.photos.count)"
        let imageViews = [Image1, Image2, Image3, Image4]

            for (index, imageView) in imageViews.enumerated() {
                if index < CoreDataService.shared.photos.count {
                    let photoEntity = CoreDataService.shared.photos[index]
                    if let imageData = photoEntity.photo {
                        imageView.image = UIImage(data: imageData)
                    }
                } else {
                    imageView.image = UIImage(named:"camera")
                }
            }
    }
    
}


