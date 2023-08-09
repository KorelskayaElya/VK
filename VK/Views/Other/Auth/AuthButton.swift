//
//  AuthButton.swift
//  VK
//
//  Created by Эля Корельская on 23.07.2023.
//

import UIKit

class AuthButton: UIButton {
    enum ButtonType {
        case signIn
        case signUp
        case alreadySignUp
        
        var title: String {
            switch self {
            case .signIn: return "Sign In"
            case .signUp: return "Sign Up"
            case .alreadySignUp: return "Already Sign Up"
            }
        }
    }
    
    let type: ButtonType

    init(type: ButtonType, title: String?) {
        self.type = type
        super.init(frame: .zero)
        if let title = title {
            setTitle(title, for: .normal)
        }
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        switch type {
        case .signIn, .signUp:
            backgroundColor = UIColor(named: "Black")
            setTitleColor(.white, for: .normal)
            titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
            layer.cornerRadius = 25
            layer.masksToBounds = true
        case .alreadySignUp:
            backgroundColor = .white
            setTitleColor(.black, for: .normal)
            titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
            layer.cornerRadius = 20
            layer.masksToBounds = true
        }
        }
    }
