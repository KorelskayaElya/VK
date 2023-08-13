//
//  StoryViewController.swift
//  VK
//
//  Created by Эля Корельская on 13.08.2023.
//

import AVFoundation
import UIKit
protocol CameraViewControllerDelegate: AnyObject {
    func cameraViewControllerDidRecordVideo(_ viewController: CameraViewController, videoURL: URL)
}
class CameraViewController: UIViewController {
    weak var delegateCamera: CameraViewControllerDelegate?

    

    // Capture Session
    var captureSession = AVCaptureSession()

    // Capture Device
    var videoCaptureDevice: AVCaptureDevice?

    // Capture Output
    var captureOutput = AVCaptureMovieFileOutput()

    // Capture Preview
    var capturePreviewLayer: AVCaptureVideoPreviewLayer?

    private let cameraView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let recordButton = RecordButton()

    private var previewLayer: AVPlayerLayer?

    var recordedVideoURL: URL?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cameraView)
        view.backgroundColor = .systemBackground
        setUpCamera()
        setupNavigationBar()
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
        view.addSubview(recordButton)
        recordButton.addTarget(self, action: #selector(didTapRecord), for: .touchUpInside)

        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: view.topAnchor),
            cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cameraView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            recordButton.widthAnchor.constraint(equalToConstant: 70),
            recordButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }

    private func setupNavigationBar() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "backarrow"), for: .normal)
        backButton.tintColor = UIColor(named: "Orange")
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
//        let saveButton = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(didTapSave))
//        saveButton.tintColor = UIColor(named: "Orange")
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
//        navigationItem.rightBarButtonItem = saveButton
    }
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc func didTapSave() {
        // передать видео
        navigationController?.popViewController(animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    @objc private func didTapRecord() {
        if captureOutput.isRecording {
            recordButton.toggle(for: .notRecording)
            captureOutput.stopRecording()
            HapticsManager.shared.vibrateForSelection()
        } else {
            guard var url = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
            ).first else {
                return
            }
            HapticsManager.shared.vibrateForSelection()

            url.appendPathComponent("video.mov")

            recordButton.toggle(for: .recording)

            try? FileManager.default.removeItem(at: url)

            captureOutput.startRecording(to: url,
                                         recordingDelegate: self)
        }
    }

    @objc private func didTapClose() {
        navigationItem.rightBarButtonItem = nil
        recordButton.isHidden = false
        if previewLayer != nil {
            previewLayer?.removeFromSuperlayer()
            previewLayer = nil
        } else {
            captureSession.stopRunning()
            tabBarController?.tabBar.isHidden = false
            tabBarController?.selectedIndex = 0
        }
    }

    func setUpCamera() {
       if let audioDevice = AVCaptureDevice.default(for: .audio) {
           let audioInput = try? AVCaptureDeviceInput(device: audioDevice)
           if let audioInput = audioInput {
               if captureSession.canAddInput(audioInput) {
                   captureSession.addInput(audioInput)
               }
           }
       }

       if let videoDevice = AVCaptureDevice.default(for: .video) {
           if let videoInput = try? AVCaptureDeviceInput(device: videoDevice) {
               if captureSession.canAddInput(videoInput) {
                   captureSession.addInput(videoInput)
               }
           }
       }

       // update session
       captureSession.sessionPreset = .hd1280x720
       if captureSession.canAddOutput(captureOutput) {
           captureSession.addOutput(captureOutput)
       }

       // configure preview
       capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
       capturePreviewLayer?.videoGravity = .resizeAspectFill
       capturePreviewLayer?.frame = view.bounds
       if let layer = capturePreviewLayer {
           cameraView.layer.addSublayer(layer)
       }

       // Enable camera start
       DispatchQueue.global(qos: .background).async { [weak self] in
           self?.captureSession.startRunning()
       }
   }
    @objc private func didTapNext() {
        guard let recordedVideoURL = recordedVideoURL else {
            return
        }

        delegateCamera?.cameraViewControllerDidRecordVideo(self, videoURL: recordedVideoURL)
        didTapClose()
    }
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {

        guard error == nil else {
            let alert = UIAlertController(title: "Woops",
                                          message: "Something went wrong when recording your video",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }

        recordedVideoURL = outputFileURL

        if UserDefaults.standard.bool(forKey: "save_video") {
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
        }
        // Кнопка сохранить
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(didTapNext))
        
        
        let player = AVPlayer(url: outputFileURL)
        previewLayer = AVPlayerLayer(player: player)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = cameraView.bounds
        guard let previewLayer = previewLayer else {
            return
        }
        recordButton.isHidden = true
        cameraView.layer.addSublayer(previewLayer)
        previewLayer.player?.play()
    }

}

    
