//
//  DatabaseManager.swift
//  VK
//
//  Created by Эля Корельская on 24.07.2023.
//

import UIKit
import FirebaseDatabase

final class DatabaseManager {
    public static let shared = DatabaseManager()
    // private потом сделать
    public let database = Database.database().reference()
    
    init() {}
    // добавление нового пользователя в базу данных
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
            // save new users object
            self?.database.child("users").setValue(usersDictionary, withCompletionBlock: { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            })
        }
    }
    // получение номера телефона из базы
    public func getPhone(for phoneNumber: String, completion: @escaping (String?) -> Void) {
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let users = snapshot.value as? [String: [String: Any]] else {
                completion(nil)
                return
            }
            for (phoneNumber, value) in users {
                if value["phoneNumber"] as? String == phoneNumber {
                    completion(phoneNumber)
                    break
                }
            }
        }
    }

    
}
