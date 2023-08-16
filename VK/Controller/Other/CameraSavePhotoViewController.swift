//
//  CameraSavePhotoViewController.swift
//  VK
//
//  Created by Эля Корельская on 16.08.2023.
//

import UIKit

class CameraPhotoSaveViewController: UIViewController {

    override var prefersStatusBarHidden: Bool {
        return true
    }

    private var backgroundImage: UIImage

    init(image: UIImage) {
        self.backgroundImage = image
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        let backgroundImageView = UIImageView(frame: view.frame)
        backgroundImageView.contentMode = UIView.ContentMode.scaleAspectFit
        backgroundImageView.image = backgroundImage
        view.addSubview(backgroundImageView)
        let cancelButton = UIButton(frame: CGRect(x: 10.0, y: 10.0, width: 30.0, height: 30.0))
        cancelButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
    }

    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
}
