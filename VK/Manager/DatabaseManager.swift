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
    
    private let database = Database.database().reference()
    
    init() {
        
    }
    public func getAllUsers(completion: (([String]) -> Void)) {
        
    }
    
}
