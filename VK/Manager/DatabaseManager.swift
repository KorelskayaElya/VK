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
}
