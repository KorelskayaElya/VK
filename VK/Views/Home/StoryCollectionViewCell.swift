//
//  StoryCollectionViewCell.swift
//  VK
//
//  Created by Эля Корельская on 07.08.2023.
//

import UIKit

import UIKit

class StoryCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = UIColor(named: "Orange") 
        layer.cornerRadius = frame.size.width / 2
        clipsToBounds = true
    }
//    func configure(with user: User) {
//        avatarImageView.sd_setImage(with: user.profilePictureURL, completed: nil)
//    }
}
