//
//  ImageManager.swift
//  VK
//
//  Created by Эля Корельская on 13.09.2023.
//


import Foundation
import UIKit
import CommonCrypto

class ImagesManager {
    
    static let shared = ImagesManager()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func cacheImage( imageData: Data, imageSize: CGSize, completion: @escaping (UIImage?) -> ())  {
        let imageDataMd5 = imageData.md5
        let cachedImageKey = NSString(string: imageDataMd5+"_"+String("\(imageSize.width)"))
        if let cachedImage = cache.object(forKey: cachedImageKey) {
            print("[ImagesManager] get cached image - \(cachedImageKey)")
            completion(cachedImage)
        }
        else {
            DispatchQueue.global(qos: .userInitiated).async {
                if let image = UIImage(data: imageData) {
                    UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
                    image.draw(in: CGRectMake(0, 0, imageSize.width, imageSize.height))
                    let cropedImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext();
                    if let cachedImage = cropedImage {
                        print("[ImagesManager] add image to cache - \(cachedImageKey)")
                        self.cache.setObject(cachedImage, forKey: cachedImageKey)
                    }
                    DispatchQueue.main.async {
                        completion(cropedImage)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }
    }
    
}

extension Data {
    var md5 : String {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        _ =  self.withUnsafeBytes { bytes in
            CC_MD5(bytes, CC_LONG(self.count), &digest)
        }
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        return digestHex
    }
}

