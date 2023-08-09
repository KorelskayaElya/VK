//
//  HapticsManager.swift
//  VK
//
//  Created by Эля Корельская on 24.07.2023.
//

import UIKit


final class HapticsManager {
    
    static let shared = HapticsManager()

    
    private init() {}

    // вибрация выбора
    public func vibrateForSelection() {
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
    // вибрация
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }
}

