//
//  AuthenticationManager.swift
//  VK
//
//  Created by Эля Корельская on 23.07.2023.
//

import Foundation
import UIKit
import FirebaseAuth

class AuthManager {
    
    public static let shared = AuthManager()
    private init() {}
    
    enum SignInMethod {
        case phone
    }
    
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    private func signIn(with method: SignInMethod) {
        
    }
    
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
