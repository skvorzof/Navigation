//
//  LoginInspector.swift
//  Navigation
//
//  Created by mitr on 31.05.2022.
//

final class LoginInspector: LoginViewControllerDelegate {
    func checkerLoginInspector(login: String, password: String) -> Bool {
        Checker.shared.checkAutentifical(login: login, password: password)
    }
}
