//
//  KeychainHelper.swift
//  Navigation
//
//  Created by Dima Skvortsov on 03.08.2022.
//

import Foundation

final class KeychaineHelper {
    static let shared = KeychaineHelper()
    private init() {}

    func savePassword(credential: Credentials) -> Bool {
        guard let data = credential.password.data(using: .utf8) else { return false }

        let query =
            [
                kSecValueData: data,
                kSecAttrService: credential.service,
                kSecAttrAccount: credential.user,
                kSecClass: kSecClassGenericPassword,
            ] as CFDictionary

        let status = SecItemAdd(query, nil)

        guard status == errSecSuccess else {
            print("Ошибка создания пароля: \(status)")
            return false
        }

        return true
    }

    func getPassword() -> String? {
        let credential = Credentials(user: "user", password: "")
        let query =
            [
                kSecReturnData: true,
                kSecAttrService: credential.service,
                kSecAttrAccount: credential.user,
                kSecClass: kSecClassGenericPassword,
            ] as CFDictionary

        var extractedData: AnyObject?
        let status = SecItemCopyMatching(query, &extractedData)

        guard status != errSecItemNotFound else {
            print("Пароль не найден, ошибка \(status)")
            return nil
        }

        guard status == errSecSuccess else {
            print("Невозможно получить пароль, ошибка \(status)")
            return nil
        }

        guard let passData = extractedData as? Data, let password = String(data: passData, encoding: .utf8) else {
            print("Ошибка преобразования пароля из Data")
            return nil
        }

        return password
    }

    func modifyPassword(_ password: String) -> Bool {
        let credentials = Credentials(user: "user", password: password)

        guard let passwordData = credentials.password.data(using: .utf8) else {
            print("Новозможно получить Data из пароля.")
            return false
        }

        let query =
            [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: credentials.service,
                kSecAttrAccount: credentials.user,
            ] as CFDictionary

        let attributesToUpdate =
            [
                kSecValueData: passwordData
            ] as CFDictionary

        let status = SecItemUpdate(query, attributesToUpdate)

        guard status == errSecSuccess else {
            print("Невозможно обновить пароль, ошибка \(status)")
            return false
        }

        return true
    }
}
