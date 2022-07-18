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

    func getResident(completion: @escaping(Result<Resident, Error>) -> Void) {
        let url = URL(string: "https://swapi.dev/api/planets/1")
        NetworkService.shared.request(url: url, expecting: Planet.self) { result in
            switch result {
            case .success(let model):
                for stringUrl in model.residents {
                    let url = URL(string: stringUrl)
                    NetworkService.shared.request(url: url, expecting: Resident.self) { result in
                        switch result {
                        case .success(let model):
                            completion(.success(model))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
