//
//  RoundDot.swift
//  VK
//
//  Created by Эля Корельская on 14.08.2023.
//
import UIKit
import SwiftyCam

class SwiftyRecordButton: SwiftyCamButton {
    // MARK: - Properties
    private var circleBorder: CALayer!
    private var innerCircle: UIView!
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        drawButton()
    }
    // MARK: - Private
    private func drawButton() {
        self.backgroundColor = UIColor.clear
        /// Создание внешнего кольца (border) кнопки для обозначения границы
        circleBorder = CALayer()
        circleBorder.backgroundColor = UIColor.clear.cgColor
        circleBorder.borderWidth = 6.0
        circleBorder.borderColor = UIColor.white.cgColor
        circleBorder.bounds = self.bounds
        circleBorder.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        circleBorder.cornerRadius = self.frame.size.width / 2
        layer.insertSublayer(circleBorder, at: 0)

    }
    /// Анимация увеличения кнопки при начале записи
    public func growButton() {
        /// Создание внутреннего круга (innerCircle) для анимации роста
        innerCircle = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        innerCircle.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        innerCircle.backgroundColor = UIColor.red
        innerCircle.layer.cornerRadius = innerCircle.frame.size.width / 2
        innerCircle.clipsToBounds = true
        self.addSubview(innerCircle)
        /// Анимация увеличения размера внутреннего круга и внешнего кольца
        UIView.animate(withDuration: 0.6, delay: 0.0, options: .curveEaseOut, animations: {
            self.innerCircle.transform = CGAffineTransform(scaleX: 62.4, y: 62.4)
            self.circleBorder.setAffineTransform(CGAffineTransform(scaleX: 1.352, y: 1.352))
            self.circleBorder.borderWidth = (6 / 1.352)

        }, completion: nil)
    }
    /// Анимация уменьшения кнопки после окончания записи
    public func shrinkButton() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.innerCircle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.circleBorder.setAffineTransform(CGAffineTransform(scaleX: 1.0, y: 1.0))
            self.circleBorder.borderWidth = 6.0
        }, completion: { (success) in
            /// Удаление внутреннего круга после анимации
            self.innerCircle.removeFromSuperview()
            self.innerCircle = nil
        })
    }
}
