//
//  PasswordCheckService.swift
//  Navigation
//
//  Created by Dima Skvortsov on 06.08.2022.
//

import UIKit

final class PasswordCheckService {

    enum PasswordState {
        case password
        case confirm
    }

    static let shared = PasswordCheckService()
    private init() {}

    var action: PasswordState = .password
    var password = ""
    var confirmPassword = ""

    func validation(textField: UITextField, complition: (String, String) -> Void) -> Bool {
        guard let text = textField.text, !text.isEmpty else { return false }
        if text.count > 3 {
            switch action {
            case .password:
                password = text
                textField.text = ""
                textField.placeholder = "Повторите пароль"
                action = .confirm
            case .confirm:
                confirmPassword = text
                if confirmPassword == password {
                    complition("", confirmPassword)
                    return true
                } else {
                    action = .password
                    textField.text = ""
                    textField.placeholder = "Введите минимум 4 символа"
                    complition("Пароли не совпадают", "")
                    return false
                }
            }
        } else {
            complition("Минимум 4 символа", "")
        }
        return false
    }
}
