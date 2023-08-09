//
//  PhotosCollectionViewCell.swift
//  VK
//
//  Created by Эля Корельская on 03.08.2023.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {

    private var photosItems: UIImageView = {
        let images = UIImageView()
        images.contentMode = .scaleAspectFill
        images.clipsToBounds = true
        images.translatesAutoresizingMaskIntoConstraints = false
        return images
    }()
    
    func setupCell(with imageName: UIImage) {
        photosItems.image = imageName
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupView() {
        self.addSubview(self.photosItems)
        NSLayoutConstraint.activate([
            self.photosItems.topAnchor.constraint(equalTo: self.topAnchor),
            self.photosItems.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.photosItems.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.photosItems.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    // готовит ячейку к перееиспользованию
    override func prepareForReuse() {
        super.prepareForReuse()
        photosItems.image = nil
    }
        
   
    
}


