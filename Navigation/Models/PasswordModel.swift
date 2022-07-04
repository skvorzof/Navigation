//
//  PasswordModel.swift
//  Navigation
//
//  Created by mitr on 08.06.2022.
//

import Foundation


enum CheckError: Error {
    case emptyPassword
    case wrongPassword
}


final class PasswordModel {
    
    func check(password: String) throws -> Bool? {
        switch password {
        case "q":
            return true
        case "":
            throw CheckError.emptyPassword
        default:
            throw CheckError.wrongPassword
        }
    }
}
