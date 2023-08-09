//
//  PhotoViewModel.swift
//  VK
//
//  Created by Эля Корельская on 03.08.2023.
//

import UIKit

// создание модели для коллекции изображений
final class PhotoViewModel {
     
     var photoArr: [String]
    // уведомляет представление об изменениях
     var photoNames: [String]? {
         didSet {
             self.photoChange?(self)
         }
     }

     init(model: [String]) {
         self.photoArr = model
     }

     var photoChange: ((PhotoViewModel) -> ())?

     func photoAdd() {
         photoNames = photoArr
     }
 }

