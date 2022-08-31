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
            let realm = try Realm()

            let users = realm.objects(UserRealmModel.self)

            return users.isEmpty ? false : true
        } catch let error as NSError {
            print("Error \(error.localizedDescription)")
        }
        return false
    }

    func create() {
        let user = UserRealmModel(login: login, password: password, _id: "")
        do {
            let realm = try Realm()

            try realm.write {
                realm.add(user)
            }
        } catch let error as NSError {
            print("Eroor \(error.localizedDescription)")
        }
    }
}
