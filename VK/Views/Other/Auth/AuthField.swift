//
//  AuthField.swift
//  VK
//
//  Created by Эля Корельская on 23.07.2023.
//

import Foundation
import UIKit

class AuthField: UITextField {

    enum FieldType {
        case phone
        case smsCode

        var placeholder: String {
            switch self {
            case .phone: return "+1-650-555-1234"
            case .smsCode: return "123-456"
            }
        }
    }

    private let type: FieldType

    init(type: FieldType) {
        self.type = type
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        autocapitalizationType = .none
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 8
        layer.masksToBounds = true
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: height))
        leftViewMode = .always
        returnKeyType = .done
        autocorrectionType = .no
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2

        placeholder = type.placeholder

        if type == .phone {
            keyboardType = .phonePad
            textContentType = .telephoneNumber
            textAlignment = .center
        } else if type == .smsCode { 
            keyboardType = .numberPad
            textContentType = .oneTimeCode
            textAlignment = .center
        }
    }
}

