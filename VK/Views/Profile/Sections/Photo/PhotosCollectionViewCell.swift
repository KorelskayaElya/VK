//
//  PhotosCollectionViewCell.swift
//  VK
//
//  Created by Эля Корельская on 03.08.2023.
//

import UIKit
/// коллекция изображений профиля
class PhotosCollectionViewCell: UICollectionViewCell {
    // MARK: - UI
    private var photosItems: UIImageView = {
        let images = UIImageView()
        images.contentMode = .scaleAspectFill
        images.clipsToBounds = true
        images.layer.cornerRadius = 25
        images.translatesAutoresizingMaskIntoConstraints = false
        return images
    }()
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    /// готовит ячейку к перееиспользованию
    override func prepareForReuse() {
        super.prepareForReuse()
        photosItems.image = nil
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Private
    private func setupView() {
        self.addSubview(self.photosItems)
        NSLayoutConstraint.activate([
            self.photosItems.topAnchor.constraint(equalTo: self.topAnchor),
            self.photosItems.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.photosItems.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.photosItems.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    /// установить изображения во " все фотографии"
    func setupCell(with photoEntity: PhotoEntity) {
        if let imageData = photoEntity.photo {
            photosItems.image = UIImage(data: imageData)
        }
    }
   
    
}


