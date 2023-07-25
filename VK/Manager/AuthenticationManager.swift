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
    
    enum AuthError: Error {
        case signInFailed
    }
    
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    // капча
    public func verifyPhoneNumber(_ phoneNumber: String, completion: @escaping (Result<String, Error>) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                completion(.failure(error))
                return 
            }
            print("\(String(describing: verificationID))")
            completion(.success(verificationID ?? "is empty"))
        }
    }
    // проверка кода
    public func verifyPhoneNumber(with verificationID: String, verificationCode: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let phoneNumber = Auth.auth().currentUser?.phoneNumber {
                completion(.success(phoneNumber))
            } else {
                completion(.failure(AuthError.signInFailed))
            }
        }
    }
    
}
