//
//  PasswordModel.swift
//  Navigation
//
//  Created by mitr on 08.06.2022.
//

import Foundation


final class PasswordModel {
    private let word: String
    
    init(word: String) {
        self.word = word
    }
    
    func check() -> Bool {
        if word == "pass" {
            return true
        }
        return false
    }
}
