//
//  ImagePicker.swift
//  VK
//
//  Created by Эля Корельская on 13.08.2023.
//

import UIKit

class ImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Properties
    static let defaultPicker = ImagePicker()

    private weak var viewController: ProfileViewController?
    
    // MARK: - Methods
    func getImage(in viewController: ProfileViewController) {
        self.viewController = viewController

        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary

        viewController.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
                               info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            viewController?.selectedImage = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
