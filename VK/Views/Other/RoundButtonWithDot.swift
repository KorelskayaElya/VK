//
//  RecordButton.swift
//  VK
//
//  Created by Эля Корельская on 13.08.2023.
//

import UIKit

class RoundButtonWithDot: UIButton {
    // MARK: - UI
    private let dotView: UIView
    // MARK: - Init
    override init(frame: CGRect) {
        dotView = UIView()
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        dotView = UIView()
        super.init(coder: aDecoder)
        setupButton()
    }
    // MARK: - Private
    private func setupButton() {
        backgroundColor = .clear
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.lightGray.cgColor
        
        dotView.backgroundColor = UIColor(named: "Black")
        dotView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dotView)
        dotView.isHidden = true
        
        dotView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dotView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        dotView.widthAnchor.constraint(equalToConstant: 8).isActive = true
        dotView.heightAnchor.constraint(equalToConstant: 8).isActive = true
        dotView.layer.cornerRadius = 4
    }
    // MARK: - Methods
    func showDot() {
        dotView.isHidden = false
    }
    
    func hideDot() {
        dotView.isHidden = true
    }
}
