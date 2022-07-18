//
//  PlanetService.swift
//  Navigation
//
//  Created by mitr on 16.07.2022.
//

import Foundation

final class PlanetService {

    static let shared = PlanetService()

    private init() {}

    func getPlanet(completion: @escaping(Result<Planet, Error>) -> Void) {
        let url = URL(string: "https://swapi.dev/api/planets/1")
        NetworkService.shared.request(url: url, expecting: Planet.self) { result in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
