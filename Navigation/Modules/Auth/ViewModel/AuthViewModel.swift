//
//  AuthViewModel.swift
//  Navigation
//
//  Created by Dima Skvortsov on 08.08.2022.
//

import Foundation
import RealmSwift

final class AuthViewModel {

    var login = ""
    var password = ""

    func validatingAuth() -> Bool {
        create()
        return true
    }

    func obtainObjects() -> Bool {
        do {
            let users = try! Realm().objects(UserRealmModel.self)
            return users.isEmpty ? false : true
        }
    }

    func create() {
        let user = UserRealmModel(login: login, password: password, _id: "")
        do {
            let realm = try! Realm()

            try! realm.write {
                realm.add(user)
            }
        }
    }

    func getRealmPath() {
        do {
            let realm = try! Realm()
            let path = realm.configuration.fileURL?.path
            print("Realm path: \(String(describing: path))")
        }
    }

}
