//
//  LoginViewModel.swift
//  Navigation
//
//  Created by mitr on 22.06.2022.
//

import Foundation

final class LoginViewModel {
    
    private let bruteForce = BruteForce()
    
    func force() -> String {
        var brutePassword: String
        brutePassword = bruteForce.bruteForce(passwordToUnlock: "fff")
        return brutePassword
    }
}
