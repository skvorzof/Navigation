//
//  NetworkService.swift
//  Navigation
//
//  Created by mitr on 12.07.2022.
//

import Foundation

// MARK: - NetworkService
struct NetworkService {
    
    enum CustomError: Error {
        case invalidUrl
        case invalidData
    }
    
    static let shared = NetworkService()

    private init() {}
    
    func request<T: Codable>(url: URL?, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = url else {
            completion(.failure(CustomError.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(CustomError.invalidData))
                }
                return
            }
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
