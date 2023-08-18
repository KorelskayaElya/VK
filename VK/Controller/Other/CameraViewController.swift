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
    private let cameraView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    /// Кнопка для захвата (записи) видео или фотографии
    private lazy var captureButton: SwiftyRecordButton = {
        let capture = SwiftyRecordButton(frame: CGRectMake(0,0,70,70))
        capture.translatesAutoresizingMaskIntoConstraints = false
        return capture
    }()
    /// Кнопка для переключения между камерами (фронтальной и задней)
    private lazy var flipCameraButton : UIButton = {
        let flipCamera = UIButton()
        flipCamera.translatesAutoresizingMaskIntoConstraints = false
        flipCamera.setImage(UIImage(systemName: "camera.rotate"), for: .normal)
        flipCamera.tintColor = UIColor(named: "Orange")
        flipCamera.addTarget(self, action: #selector(cameraSwitchTapped), for: .touchUpInside)
        return flipCamera
    }()
    /// Кнопка для управления вспышкой
    private lazy var flashButton : UIButton = {
        let flashButton = UIButton()
        flashButton.tintColor = UIColor(named: "Orange")
        flashButton.translatesAutoresizingMaskIntoConstraints = false
        flashButton.addTarget(self, action: #selector(toggleFlashTapped), for: .touchUpInside)
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
        /// всегда вспышка
        flashMode = .on
        flashButton.setImage(UIImage(systemName: "bolt.fill"), for: .normal)
        customizeBackButton()
        view.addSubview(cameraView)
        cameraView.addSubview(captureButton)
        captureButton.buttonEnabled = false
        cameraView.addSubview(flipCameraButton)
        cameraView.addSubview(flashButton)
        
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
            cameraView.topAnchor.constraint(equalTo: view.topAnchor),
            cameraView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            // Констрейнты для captureButton
            captureButton.centerXAnchor.constraint(equalTo: cameraView.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: cameraView.bottomAnchor, constant: -120),
            captureButton.widthAnchor.constraint(equalToConstant: 70),
            captureButton.heightAnchor.constraint(equalToConstant: 70),
            
            // Констрейнты для flipCameraButton
            flipCameraButton.topAnchor.constraint(equalTo: cameraView.topAnchor, constant: 20),
            flipCameraButton.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor, constant: -20),
            flipCameraButton.widthAnchor.constraint(equalToConstant: 50),
            flipCameraButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Констрейнты для flashButton
            flashButton.topAnchor.constraint(equalTo: cameraView.topAnchor, constant: 20),
            flashButton.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor, constant: 20),
            flashButton.widthAnchor.constraint(equalToConstant: 50),
            flashButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    /// кнопка назад
    private func customizeBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "backarrow"), for: .normal)
        backButton.tintColor = UIColor(named: "Orange")
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
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
    /// сохранение изображения
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        let newVC = CameraPhotoSaveViewController(image: photo)
        self.present(newVC, animated: true, completion: nil)
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
        /// по умолчанию всегда при записи видео
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
        let focusView = UIImageView()
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

