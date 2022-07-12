//
//  NetworkService.swift
//  Navigation
//
//  Created by mitr on 12.07.2022.
//

import Foundation

// MARK: - NetworkService
struct NetworkService {
    static let shared = NetworkService()

    private init() {}
    
    func getUrlSession(stingUrl: String) {
        if let url = URL(string: stingUrl) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let response = response as? HTTPURLResponse {
                    print("ОТВЕТ СЕРВЕРА (statusCode): \(response.statusCode)")
                    print("ОТВЕТ СЕРВЕРА (Header)¬\n\(response.allHeaderFields)\n")
                    print("ОТВЕТ СЕРВЕРА (data)¬\n\(String(decoding: data, as: UTF8.self))\n")
                } else {
                    if let error = error {
                        print("ОШИБКА:\n \(error)")
                    }
                }
            }
            task.resume()
        }
    }
}
