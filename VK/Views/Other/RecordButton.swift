//
//  RecordButton.swift
//  VK
//
//  Created by Эля Корельская on 13.08.2023.
//

import UIKit

class RecordButton: UIButton {
    // MARK: Enum
    enum State {
        case recording
        case notRecording
    }
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = nil
        layer.masksToBounds = true
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2.5
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = height/2
    }
    // MARK: - Methods
    public func toggle(for state: State) {
        switch state {
        case .recording:
            backgroundColor = .systemRed
        case .notRecording:
            backgroundColor = nil
        }
    }

}

