//
//  UserRealmModel.swift
//  Navigation
//
//  Created by Dima Skvortsov on 08.08.2022.
//

import Foundation
import RealmSwift

final class UserRealmModel: Object {
    @objc dynamic var login = ""
    @objc dynamic var password = ""
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    
    convenience init(login: String, password: String, _id: String) {
        self.init()
        self.login = login
        self.password = password
    }
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
