//
//  TodoService.swift
//  Navigation
//
//  Created by mitr on 15.07.2022.
//

import Foundation

class TodoService {

    static let shared = TodoService()

    private init() {}

    // MARK: - fetch
    func fetch(from url: URL, complition: @escaping (Result<Todo, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, res, err in
            if let err = err {
                complition(.failure(err))
            }

            if let data = data {
                do {
                    let todo = try JSONDecoder().decode(Todo.self, from: data)
                    complition(.success(todo))
                } catch let err {
                    complition(.failure(err))
                }
            }
        }
        task.resume()
    }

    // MARK: - getTodo
    func getTodo(stringUrl: String) {
        if let url = URL(string: stringUrl) {
            let task = URLSession.shared.dataTask(with: url) { data, responce, error in
                if let data = data {
                    do {
                        let data = try JSONSerialization.jsonObject(with: data, options: [])

                        if let todo = data as? [String: Any] {
                            let userId = todo["userId"] as? Int ?? 0
                            let id = todo["id"] as? Int ?? 0
                            let title = todo["title"] as? String ?? ""
                            let completed = todo["completed"] as? Bool ?? false

                            print("userId: \(userId)")
                            print("id: \(id)")
                            print("title: \(title)")
                            print("completed: \(completed)")
                        }
                    } catch let error {
                        print("Error JSONSerialization \(error)")
                    }
                }
            }
            task.resume()
        }
    }
}
