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

    func fetchPlanet(with urlString: String, completion: @escaping (Result<Planet, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, resp, err in
            guard let data = data, err == nil else { return }

            do {
                let planet = try JSONDecoder().decode(Planet.self, from: data)
                completion(.success(planet))
            } catch let err {
                completion(.failure(err))
            }
        }
        task.resume()
    }
}
