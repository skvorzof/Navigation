//
//  DatabaseCoordinatable.swift
//  Navigation
//
//  Created by Dima Skvortsov on 08.08.2022.
//

import Foundation

enum DatabaseError: Error {
    case wrongModel
    case error(description: String)
    case unknown
}

protocol DatabaseCoordinatable {}
