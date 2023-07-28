//
//  AlertManager.swift
//  VK
//
//  Created by Эля Корельская on 28.07.2023.
//

import UIKit


final class AlertManager {
    
    static func showAlert(on viewController: UIViewController, with title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
}

