//
//  RealmManager.swift
//  VK
//
//  Created by Эля Корельская on 21.08.2023.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static let defaultManager = RealmManager()
    
    var users: Results<Users> {
        let realm = try! Realm()
        return realm.objects(Users.self)
    }
    
    func addUser(name: String) {
        let realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL)
        let user = Users()
        user.identifier = "annaux_designer"
        user.username = "Анна Мищенко"
        user.status = "дизайнер"
        user.gender = "Женский"
        user.birthday = "01.02.1997"
        user.city = "Москва"
        user.hobby = "футбол"
        user.school = "Дизайнер"
        user.university = "школа 134"
        user.work = "Московский"

        try! realm.write {
            realm.add(user)
        }
    }
    
}
