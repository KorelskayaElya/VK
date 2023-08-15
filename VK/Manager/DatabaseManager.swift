//
//  DatabaseManager.swift
//  VK
//
//  Created by Эля Корельская on 24.07.2023.
//

import UIKit
import FirebaseDatabase

enum DatabaseError: Error {
    case noData
    case phoneNumberNotFound
}

final class DatabaseManager {
    
    public static let shared = DatabaseManager()
    
    public let database = Database.database().reference()
    
    init() {}
    
    /// добавление нового пользователя в базу данных
    public func insertUser(with phoneNumber: String, completion: @escaping (Bool) -> Void) {
        database.child("users").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard var usersDictionary = snapshot.value as? [String: Any] else {
                self?.database.child("users").setValue(
                    [
                        phoneNumber: [
                            "phoneNumber": phoneNumber
                        ]
                    ]
                ) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
                return
            }
            usersDictionary[phoneNumber] = ["phoneNumber": phoneNumber]
            ///  сохранение нового пользователя
            self?.database.child("users").setValue(usersDictionary, withCompletionBlock: { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            })
        }
    }
    /// проверка номера телефона в базе
    public func getPhone(for phoneNumber: String, completion: @escaping (Result<String, Error>) -> Void) {
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let users = snapshot.value as? [String: [String: Any]] else {
                completion(.failure(DatabaseError.noData))
                return
            }
            for (key, value) in users {
                if let valuePhoneNumber = value["phoneNumber"] as? String, valuePhoneNumber == phoneNumber {
                    completion(.success(key))
                    return
                }
            }
            completion(.failure(DatabaseError.phoneNumberNotFound))
        }
    }
//    /// добавить пост
//    public func insertPost(fileName: String, caption: String, completion: @escaping (Bool) -> Void) {
//        guard let username = UserDefaults.standard.string(forKey: "phoneNumber") else {
//            completion(false)
//            return
//        }
//
//        database.child("users").child(username).observeSingleEvent(of: .value) { [weak self] snapshot in
//            guard var value = snapshot.value as? [String: Any] else {
//                completion(false)
//                return
//            }
//
//            let newEntry = [
//                
//            ]
//
//            if var posts = value["posts"] as? [[String: Any]] {
//                posts.append(newEntry)
//                value["posts"] = posts
//                self?.database.child("users").child(username).setValue(value) { error, _ in
//                    guard error == nil else {
//                        completion(false)
//                        return
//                    }
//                    completion(true)
//                }
//            } else {
//                value["posts"] = [newEntry]
//                self?.database.child("users").child(username).setValue(value) { error, _ in
//                    guard error == nil else {
//                        completion(false)
//                        return
//                    }
//                    completion(true)
//                }
//            }
//        }
//    }

//    /// уведомления
//    public func getNotifications(completion: @escaping ([Notification]) -> Void) {
//        completion()
//    }
//
//    /// скрыть уведомление
//    public func markNotificationAsHidden(notificationID: String, completion: @escaping (Bool) -> Void) {
//        completion(true)
//    }

    ///
//    public func getPosts(for user: User, completion: @escaping ([Post]) -> Void) {
//        let path = "users/\(user.username.lowercased())/posts"
//        database.child(path).observeSingleEvent(of: .value) { snapshot in
//            guard let posts = snapshot.value as? [[String: String]] else {
//                completion([])
//                return
//            }
//
//            let models: [Post] = posts.compactMap({
//                var model = Post(identifier: UUID().uuidString,
//                          user: user)
//                return model
//            })
//
//            completion(models)
//        }
//    }

//   /// подписаться
//    public func getRelationships(
//        for user: User,
//        type: ,
//        completion: @escaping ([String]) -> Void
//    ) {
//        let path = "users/\(user.username.lowercased())/\(type.rawValue)"
//
//        database.child(path).observeSingleEvent(of: .value) { snapshot in
//            guard let usernameCollection = snapshot.value as? [String] else {
//                completion([])
//                return
//            }
//
//            completion(usernameCollection)
//        }
//    }

//    /// отписаться
//    public func isValidRelationship(
//        for user: User,
//        type: ,
//        completion: @escaping (Bool) -> Void
//    ) {
//        guard let currentUserUsername = UserDefaults.standard.string(forKey: "phoneNumber")?.lowercased() else {
//            return
//        }
//
//        let path = "users/\(user.username.lowercased())/\(type.rawValue)"
//
//        database.child(path).observeSingleEvent(of: .value) { snapshot in
//            guard let usernameCollection = snapshot.value as? [String] else {
//                completion(false)
//                return
//            }
//
//            completion(usernameCollection.contains(currentUserUsername))
//        }
//    }

}
