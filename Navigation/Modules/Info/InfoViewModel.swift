//
//  InfoViewModel.swift
//  Navigation
//
//  Created by mitr on 15.07.2022.
//

import Foundation

final class InfoViewModel {

    var todoTitle = ObservableObject("")

    func get() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/13")
        guard let url = url else { return }
        TodoService.shared.fetchTodo(from: url) { [weak self] data in
            switch data {
            case .success(let todo):
                self?.todoTitle.value = todo.title
            case .failure(let err):
                print("\(err.localizedDescription)")
            }
        }
    }
}
