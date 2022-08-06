//
//  PasswordViewModel.swift
//  Navigation
//
//  Created by Dima Skvortsov on 03.08.2022.
//

import UIKit

enum Mode {
    case check
    case create
    case modify
}

// MARK: - PasswordViewModel
final class PasswordViewModel {

    var mode: Mode = .check
    private var keychainPassword = ""
    var password = ""
    var sendMessage: ((String) -> Void)?

    init() {
        if let responseKeychainPassword = KeychaineHelper.shared.getPassword() {
            mode = .check
            keychainPassword = responseKeychainPassword
        } else {
            mode = .create
        }
    }

    func passwordValidation(textField: UITextField) -> Bool {
        if PasswordCheckService.shared.validation(
            textField: textField,
            complition: { message, validPassword in
                password = validPassword
                if !message.isEmpty {
                    sendMessage?(message)
                }
            })
        {
            return true
        } else {
            return false
        }
    }

    func checkPassword() -> Bool {
        return password == keychainPassword
    }

    func savePassword() {
        let credential = Credentials(user: "user", password: password)
        if KeychaineHelper.shared.savePassword(credential: credential) {
            sendMessage?("Пароль успешно сохранён.")
        }
    }

    func changePassword() {
        if KeychaineHelper.shared.modifyPassword(password) {
            sendMessage?("Пароль успешно изменён.")
        }
    }
}
