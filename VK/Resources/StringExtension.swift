//
//  StringExtension.swift
//  VK
//
//  Created by Эля Корельская on 17.08.2023.
//

import UIKit

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}

