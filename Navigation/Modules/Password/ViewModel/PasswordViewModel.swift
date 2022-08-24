//
//  PasswordViewModel.swift
//  Navigation
//
//  Created by Dima Skvortsov on 03.08.2022.
//

import UIKit

enum AuthState {
    case password
    case confirm
    case create
    case modify
}

// MARK: - PasswordViewModel
final class PasswordViewModel {

    var sendMessage: ((String) -> Void)?
    var authState: AuthState = .password
    private var password = ""
    private var confirmPassword = ""
    private var keychainPassword = ""

    init() {
        if let responseKeychainPassword = KeychaineHelper.shared.getPassword() {
            authState = .password
            keychainPassword = responseKeychainPassword
        } else {
            authState = .create
        }
    }

    func validateTextField(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        switch authState {
        case .password:
            password = text
            textField.text = ""
            textField.placeholder = "Confirm"
        case .confirm:
            confirmPassword = text
            if confirmPassword == password {
                print(confirmPassword, password)
                if checkPassword() {
                    return true
                } else {
                    sendMessage?("Неверный пароль")
                    textField.placeholder = "Введите минимум 4 символа"
                    authState = .password
                }
            } else {
                sendMessage?("Password deferent")
            }
        case .create:
            savePassword()
        case .modify:
            break
        }
        return false
    }

    func checkPassword() -> Bool {
        return confirmPassword == keychainPassword
    }

    func savePassword() {
        let credential = Credentials(user: "user", password: password)
        if KeychaineHelper.shared.savePassword(credential: credential) {
            sendMessage?("Пароль успешно сохранён.")
        }
    }

    func changePassword(_ password: String) {
        if KeychaineHelper.shared.modifyPassword(password) {
            sendMessage?("Пароль успешно изменён.")
        }
    }
}
