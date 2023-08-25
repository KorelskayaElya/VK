//
//  CameraSavePhotoViewController.swift
//  VK
//
//  Created by Эля Корельская on 16.08.2023.
//

import UIKit

protocol CameraPhotoSaveDelegate: AnyObject {
    func cameraPhototSave(_ image: UIImage)
}

class CameraPhotoSaveViewController: UIViewController {
    // MARK: - Properties
    private var backgroundImage: UIImage
    weak var delegate: CameraPhotoSaveDelegate?
    // MARK: - Init
    init(image: UIImage) {
        self.backgroundImage = image
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        
        let backgroundImageView = UIImageView(frame: view.frame)
        backgroundImageView.contentMode = UIView.ContentMode.scaleAspectFit
        backgroundImageView.image = backgroundImage
       
        let cancelButton = UIButton(frame: CGRect(x: 10.0, y: 10.0, width: 30.0, height: 30.0))
        cancelButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        cancelButton.tintColor = UIColor(named: "Orange")
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        let saveButton = UIButton(frame: CGRect(x: view.bounds.width-50, y: 10.0, width: 30.0, height: 30.0))
        saveButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        saveButton.tintColor = UIColor(named: "Orange")
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        view.addSubview(backgroundImageView)
        view.addSubview(saveButton)
        view.addSubview(cancelButton)
    }
    // MARK: - Private
    /// отмена сохранения
    @objc private func cancel() {
        dismiss(animated: true, completion: nil)
    }
    /// установка изображения в профиль
    @objc private func save() {
       delegate?.cameraPhototSave(backgroundImage)
       dismiss(animated: true, completion: nil)
    }
    
}
