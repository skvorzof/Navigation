//
//  Todo.swift
//  Navigation
//
//  Created by mitr on 15.07.2022.
//

import Foundation

struct Todo: Codable {
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool
}
