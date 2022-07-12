//
//  AppConfiguration.swift
//  Navigation
//
//  Created by mitr on 12.07.2022.
//

import Foundation

// MARK: - AppConfiguration
enum AppConfiguration: String, CaseIterable {
    case peopleUrl = "https://swapi.dev/api/people/8"
    case starshipsUrl = "https://swapi.dev/api/starships/3"
    case planetUrl = "https://swapi.dev/api/planets/5"
    
    static func getRandomUrl() -> String {
        AppConfiguration.allCases.randomElement()?.rawValue ?? "Error generate random url!"
    }
}
