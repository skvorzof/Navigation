//
//  PasswordModel.swift
//  Navigation
//
//  Created by mitr on 08.06.2022.
//

import Foundation


final class PasswordModel {
    private let word = "pass"
    
    func check(password: String) -> Bool {
        password == word
    }
}
