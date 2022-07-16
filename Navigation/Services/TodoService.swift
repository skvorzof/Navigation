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
    func fetchTodo(from url: URL, complition: @escaping (Result<Todo, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, res, err in

            if let data = data {
                do {
                    let data = try JSONSerialization.jsonObject(with: data, options: [])
                    if let todo = data as? [String: Any] {
                        let userId = todo["userId"] as? Int ?? 0
                        let id = todo["id"] as? Int ?? 0
                        let title = todo["title"] as? String ?? ""
                        let completed = todo["completed"] as? Bool ?? false

                        complition(
                            .success(
                                Todo(userId: userId, id: id, title: title, completed: completed))
                        )
                    }

                } catch let err {
                    complition(.failure(err))
                }
            }
        }
        task.resume()
    }

}
