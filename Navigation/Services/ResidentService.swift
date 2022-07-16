//
//  ResidentService.swift
//  Navigation
//
//  Created by mitr on 16.07.2022.
//

import Foundation

// MARK: - ResidentService
final class ResidentService {

    static let shared = ResidentService()

    private init() {}

    func fetchResident(completion: @escaping(Result<String, Error>) -> Void) {

        let urlString = "https://swapi.dev/api/planets/1"
        PlanetService.shared.fetchPlanet(with: urlString) { data in
            switch data {
            case .success(let model):
                for modelUrl in model.residents {
                    guard let url = URL(string: modelUrl) else { return }
                    let task = URLSession.shared.dataTask(with: url) { data, resp, err in
                        guard let data = data, err == nil else { return }

                        do {
                            let resident = try JSONDecoder().decode(Resident.self, from: data)
                            completion(.success(resident.name))
                        } catch let err {
                            completion(.failure(err))
                        }
                    }
                    task.resume()
                }

            case .failure(let err):
                print("Error \(err)")
            }
        }

    }
}
