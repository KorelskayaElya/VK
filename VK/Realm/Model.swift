//
//  Model.swift
//  VK
//
//  Created by Эля Корельская on 21.08.2023.
//

import Foundation
import RealmSwift
import UIKit


// Realm.Configuration.defaultConfiguretion.fileURL
class Users: Object {
    @objc dynamic var identifier: String = ""
    @objc dynamic var username: String = ""
    @objc dynamic var status: String = ""
    @objc dynamic var gender: String = ""
    @objc dynamic var birthday: String = ""
    @objc dynamic var city: String = ""
    @objc dynamic var hobby: String = ""
    @objc dynamic var school: String = ""
    @objc dynamic var university: String = ""
    @objc dynamic var work: String = ""
}
