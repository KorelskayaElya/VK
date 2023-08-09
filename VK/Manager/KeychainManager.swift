//
//  KeychainManager.swift
//  VK
//
//  Created by Эля Корельская on 07.08.2023.
//

import Foundation
import KeychainAccess

class KeychainManager {
    static let shared = KeychainManager()
    
    private let keychain = Keychain(service: "Elya.VK")
    
    private init() {}
    // сохранение ключа входа
    func saveSignInFlag(_ isSignedIn: Bool) {
        do {
            try keychain
                .label("SignInFlag")
                .set(isSignedIn.description, key: "isSignedIn")
        } catch {
            print("Error saving sign-in flag to Keychain: \(error)")
        }
    }
    // проверка ключа входа
    func getSignInFlag() -> Bool? {
        do {
            if let value = try keychain
                .label("SignInFlag")
                .get("isSignedIn") {
                return Bool(value)
            }
        } catch {
            print("Error getting sign-in flag from Keychain: \(error)")
        }
        return nil
    }
}
