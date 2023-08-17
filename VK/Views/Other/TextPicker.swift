//
//  TextPicker.swift
//  VK
//
//  Created by Эля Корельская on 16.08.2023.
//

import UIKit

class TextPicker {
    
    // MARK: - Properties
    static let defaultPicker = TextPicker()
    
    // MARK: - Private
    /// используется для создания текстового файла
    func getText(showPickerIn viewController: UIViewController, title: String, message: String, completion: ((_ text1: String, _ text2: String)->())?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField()
        alertController.addTextField()

        let alertOK = UIAlertAction(title: "OK", style: .default) { alert in
            if let text1  = alertController.textFields?[0].text, text1 != "",
               let text2  = alertController.textFields?[1].text, text2 != ""
            {
                completion?(text1, text2)
            }
        }
        let alertCancel = UIAlertAction(title: "Cancel".localized, style: .cancel)
        alertController.addAction(alertOK)
        alertController.addAction(alertCancel)
        viewController.present(alertController,animated: true)
    }
}

