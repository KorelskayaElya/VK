//
//  StoryViewController.swift
//  VK
//
//  Created by Эля Корельская on 13.08.2023.
//

import UIKit
import AVFoundation
import SwiftyCam

class CameraViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate {
    
    // MARK: - UI
    // нужно ли это не понятно
//    private let cameraView: UIView = {
//        let view = UIView()
//        view.clipsToBounds = true
//        view.backgroundColor = .black
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    /// Кнопка для захвата (записи) видео или фотографии
    private lazy var captureButton: SwiftyRecordButton = {
        let capture = SwiftyRecordButton()
        capture.translatesAutoresizingMaskIntoConstraints = false
        capture.addTarget(self, action: #selector(cameraSwitchTapped), for: .touchUpInside)
        return capture
    }()
    /// Кнопка для переключения между камерами (фронтальной и задней)
    private lazy var flipCameraButton : UIButton = {
        let flipCamera = UIButton()
        flipCamera.translatesAutoresizingMaskIntoConstraints = false
        flipCamera.addTarget(self, action: #selector(toggleFlashTapped), for: .touchUpInside)
        return flipCamera
    }()
    /// Кнопка для управления вспышкой
    private lazy var flashButton : UIButton = {
        let flashButton = UIButton()
        flashButton.translatesAutoresizingMaskIntoConstraints = false
        return flashButton
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Настройки SwiftyCam
        shouldPrompToAppSettings = true
        cameraDelegate = self
        /// максимальная продолжительность видео
        maximumVideoDuration = 10.0
        /// ориентация фотографии портретная
        shouldUseDeviceOrientation = false
        allowAutoRotate = true
        audioEnabled = true
        flashMode = .auto
        flashButton.setImage(UIImage(systemName: "flashlight.on.fill"), for: .normal)
        customizeBackButton()
        view.addSubview(captureButton)
        captureButton.buttonEnabled = false
        view.addSubview(flipCameraButton)
        view.addSubview(flashButton)
        constraints()
       
    }
    /// Скрытие статус-бара
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureButton.delegate = self
    }
    // MARK: - Private
    private func constraints() {
        NSLayoutConstraint.activate([
            // Констрейнты для captureButton
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            captureButton.widthAnchor.constraint(equalToConstant: 70),
            captureButton.heightAnchor.constraint(equalToConstant: 70),
            
            // Констрейнты для flipCameraButton
            flipCameraButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            flipCameraButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            flipCameraButton.widthAnchor.constraint(equalToConstant: 40),
            flipCameraButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Констрейнты для flashButton
            flashButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            flashButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            flashButton.widthAnchor.constraint(equalToConstant: 40),
            flashButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    /// кнопка назад
    private func customizeBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "backarrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let customBackButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = customBackButton
    }
    /// навигация назад
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    /// сессия начала выполняться
    func swiftyCamSessionDidStartRunning(_ swiftyCam: SwiftyCamViewController) {
        print("Session did start running")
        captureButton.buttonEnabled = true
    }
    /// сессия закончилась
    func swiftyCamSessionDidStopRunning(_ swiftyCam: SwiftyCamViewController) {
        print("Session did stop running")
        captureButton.buttonEnabled = false
    }
    
    /// начало записи видео
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did Begin Recording")
        /// кнопка увеличивается при начале записи
        captureButton.growButton()
        hideButtons()
    }
    /// окончание записи видео
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did finish Recording")
        /// кнопка уменьшается при окончании записи
        captureButton.shrinkButton()
        showButtons()
    }
    /// сохранение записанного видео
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        let newVC = VideoViewController(videoURL: url)
        self.present(newVC, animated: true, completion: nil)
    }
    /// сделать фокусировку в точке
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        print("Did focus at point: \(point)")
        focusAnimationAt(point)
    }
    /// ошибка конфигурации камеры
    func swiftyCamDidFailToConfigure(_ swiftyCam: SwiftyCamViewController) {
        let message = NSLocalizedString("Unable to capture media", comment: "Alert message when something goes wrong during capture session configuration")
        let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    /// поменять зум
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        print("Zoom level did change. Level: \(zoom)")
        print(zoom)
    }
    /// переклчить камеру
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        print("Camera did change to \(camera.rawValue)")
        print(camera)
    }
    /// ошибка при записи видео
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFailToRecordVideo error: Error) {
        print(error)
    }
    /// Обработка нажатия на кнопку переключения камеры
    @objc private func cameraSwitchTapped(_ sender: Any) {
        switchCamera()
    }
    /// Обработка нажатия на кнопку управления вспышкой
    @objc private func toggleFlashTapped(_ sender: Any) {
        //flashEnabled = !flashEnabled
        toggleFlashAnimation()
    }
}


// UI Animations
extension CameraViewController {
    /// Скрытие кнопок
    fileprivate func hideButtons() {
        UIView.animate(withDuration: 0.25) {
            self.flashButton.alpha = 0.0
            self.flipCameraButton.alpha = 0.0
        }
    }
    /// Показ кнопок
    fileprivate func showButtons() {
        UIView.animate(withDuration: 0.25) {
            self.flashButton.alpha = 1.0
            self.flipCameraButton.alpha = 1.0
        }
    }
    /// Анимация фокуса на точке нажатия
    fileprivate func focusAnimationAt(_ point: CGPoint) {
        let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
        focusView.center = point
        focusView.alpha = 0.0
        view.addSubview(focusView)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            focusView.alpha = 1.0
            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }) { (success) in
            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                focusView.alpha = 0.0
                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
            }) { (success) in
                focusView.removeFromSuperview()
            }
        }
    }
    /// Анимация переключения режимов вспышки
    fileprivate func toggleFlashAnimation() {
        //flashEnabled = !flashEnabled
        if flashMode == .auto{
            flashMode = .on
            flashButton.setImage(#imageLiteral(resourceName: "flash"), for: UIControl.State())
        }else if flashMode == .on{
            flashMode = .off
            flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControl.State())
        }else if flashMode == .off{
            flashMode = .auto
            flashButton.setImage(#imageLiteral(resourceName: "flashauto"), for: UIControl.State())
        }
    }
}

