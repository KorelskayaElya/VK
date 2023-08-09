//
//  LineView.swift
//  VK
//
//  Created by Эля Корельская on 29.07.2023.
//

import UIKit

final class LineView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = .gray
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 1).isActive = true 
    }
}

