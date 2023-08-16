//
//  VideoViewController.swift
//  VK
//
//  Created by Эля Корельская on 16.08.2023.
//

import UIKit
import AVFoundation
import AVKit

class VideoViewController: UIViewController {
    // MARK: - UI
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Properties
    private var videoURL: URL
    var player: AVPlayer?
    var playerController : AVPlayerViewController?
    
    // MARK: - Init
    init(videoURL: URL) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Настройка внешнего вида контроллера
        self.view.backgroundColor = UIColor.gray
        
        /// Создание AVPlayer и AVPlayerViewController
        player = AVPlayer(url: videoURL)
        playerController = AVPlayerViewController()
        
        /// Проверка наличия player и playerController
        guard player != nil && playerController != nil else {
            return
        }
        /// Отключение отображения элементов управления воспроизведением
        playerController!.showsPlaybackControls = false
        
        /// Привязка player к playerController
        playerController!.player = player!
        self.addChild(playerController!)
        self.view.addSubview(playerController!.view)
        playerController!.view.frame = view.frame
        
        /// Настройка обработки окончания воспроизведения видео
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player!.currentItem)
        
        /// Добавление кнопки отмены
        let cancelButton = UIButton(frame: CGRect(x: 10.0, y: 10.0, width: 30.0, height: 30.0))
        cancelButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        /// Настройка категории аудиосессии для воспроизведения звука
        do {
            if #available(iOS 10.0, *) {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: [])
            } else {
                /// Обработка для более старых версий iOS
            }
        } catch let error as NSError {
            print(error)
        }
        
        /// Активация аудиосессии для воспроизведения звука
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print(error)
        }
    }
    
    /// Воспроизведение видео при появлении контроллера на экране
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }
    
    // MARK: - Methods
    /// Обработка нажатия кнопки отмены
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    /// Обработка окончания воспроизведения видео
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        if self.player != nil {
            // Перемотка видео к началу и продолжение воспроизведения
            self.player!.seek(to: CMTime.zero)
            self.player!.play()
        }
    }
}

/// Преобразование типа AVAudioSession.Category в строку
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
    return input.rawValue
}
