//
//  LabelFutherInformationField.swift
//  VK
//
//  Created by Эля Корельская on 18.08.2023.
//

import UIKit

final class LabelFutherInformationField: UILabel {
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    // MARK: - Private
    private func commonInit() {
        self.textColor = UIColor.createColor(lightMode: .black, darkMode: .white)
        self.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.numberOfLines = 0
    }
}

