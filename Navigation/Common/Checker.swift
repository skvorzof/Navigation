//
//  Checker.swift
//  Navigation
//
//  Created by mitr on 31.05.2022.
//

final class Checker {
    static let shared = Checker()
    private let login = "q".hash
    private let password = "q".hash
    
    private init() {}
    
    func checkAutentifical(login: String, password: String) -> Bool {
        self.login == login.hash && self.password == password.hash
    }
}
