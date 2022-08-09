//
//  AuthService.swift
//  Navigation
//
//  Created by Dima Skvortsov on 08.08.2022.
//

import Foundation

final class AuthService {
    static let shared = AuthService()
    private init() {}
    
    func validateLogin(login: String) -> Bool {
        return true
    }
}
