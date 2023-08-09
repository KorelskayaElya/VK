//
//  IconImage.swift
//  VK
//
//  Created by Эля Корельская on 29.07.2023.
//

import UIKit

class IconImageUtility {
    static func iconImage(named systemName: String, tintColor: UIColor) -> UIImage? {
        let image = UIImage(systemName: systemName)?.withTintColor(tintColor)
        return image
    }
}
