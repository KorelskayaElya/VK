//
//  StorageManager.swift
//  VK
//
//  Created by Эля Корельская on 15.08.2023.
//

import Foundation
import FirebaseStorage

///  хранилище
final class StorageManager {

    public static let shared = StorageManager()


    private let storageBucket = Storage.storage().reference()


    private init() {}

   // MARK: - Public

    /// добавление сторис
    public func uploadVideo(from url: URL, fileName: String, completion: @escaping (Bool) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "phoneNumber") else {
            return
        }

        storageBucket.child("videos/\(username)/\(fileName)").putFile(from: url, metadata: nil) { _, error in
            completion(error == nil)
        }
    }

    /// фото профиля
    public func uploadProfilePicture(with image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "phoneNumber") else {
            return
        }

        guard let imageData = image.pngData() else {
            return
        }

        let path = "profile_pictures/\(username)/picture.png"

        storageBucket.child(path).putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                self.storageBucket.child(path).downloadURL { url, error in
                    guard let url = url else {
                        if let error = error {
                            completion(.failure(error))
                        }
                        return
                    }

                    completion(.success(url))
                }
            }
        }
    }

   /// создать название видео
    public func generateVideoName() -> String {
        let uuidString = UUID().uuidString
        let number = Int.random(in: 0...1000)
        let unixTimestamp = Date().timeIntervalSince1970

        return uuidString + "_\(number)_" + "\(unixTimestamp)" + ".mov"
    }

}

