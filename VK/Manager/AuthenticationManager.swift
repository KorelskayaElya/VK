//
//  AuthenticationManager.swift
//  VK
//
//  Created by Эля Корельская on 23.07.2023.
//

import UIKit
import FirebaseAuth


final class AuthManager {
    
    public static let shared = AuthManager()
    
    private init() {}
    
    private var verificationId: String?
    
    // + 16505551234/ + 16505551111 - 123456 есть в системе
    // + 16505552222/ +16505554321 - 123456 тестовые - их еще нет в базе
    
    /// капча
    public func startAuth(phoneNumber: String, completion: @escaping (Bool, String?) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            guard let verificationId = verificationID else {
                completion(false, "Verification ID not found.")
                return
            }
            self?.verificationId = verificationId
            completion(true, nil)
        }
    }
    /// проверка кода
    public func verifyCode(phoneNumber: String, smsCode: String, completion: @escaping (Bool, String?) -> Void) {
        guard let verificationId = self.verificationId else {
            completion(false, "Verification ID not found.")
            return
        }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: smsCode)
        
        Auth.auth().signIn(with: credential) { [weak self] result, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            self?.signUp(with: phoneNumber) { success, errorMessage in
                if success {
                    UserDefaults.standard.setValue(phoneNumber, forKey: "phoneNumber") // Здесь сохраняется номер телефона
                    completion(true, nil)
                } else {
                    completion(false, errorMessage ?? "Error saving user in the database.")
                }
            }
        }
    }
    /// регистрация
    public func signUp(with phoneNumber: String, completion: @escaping (Bool, String?) -> Void) {
        DatabaseManager.shared.getPhone(for: phoneNumber) { result in
            switch result {
            case .success:

                completion(false, "The phone number \(phoneNumber) is already registered.")
            case .failure(DatabaseError.phoneNumberNotFound):
            
                DatabaseManager.shared.insertUser(with: phoneNumber) { success in
                    if success {
                        completion(true, nil)
                    } else {
                        completion(false, "Error saving user in the database.")
                    }
                }
            case .failure(let error):

                completion(false, error.localizedDescription)
            }
        }
    }
    /// вход
    public func signIn(with phone: String, completion: @escaping (Result<String, Error>) -> Void) {
        DatabaseManager.shared.getPhone(for: phone) { result in
            switch result {
            case .success(let userId):
                completion(.success(userId))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    /// выход из аккаунта
    public func signOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch {
            print(error)
            completion(false)
        }
    }
}
