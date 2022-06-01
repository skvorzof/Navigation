//
//  Checker.swift
//  Navigation
//
//  Created by mitr on 31.05.2022.
//

final class Checker {
    static let shared = Checker()
    private let login = "q"
    private let password = "q"
    
    private init() {}
    
    func checkAutentifical(login: String, password: String) -> Bool {
        if self.login == login && self.password == password {
            return true
        }
        return false
    }
}
