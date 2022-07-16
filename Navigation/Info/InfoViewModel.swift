//
//  InfoViewModel.swift
//  Navigation
//
//  Created by mitr on 15.07.2022.
//

import Foundation

final class InfoViewModel {

    enum Action {
        case todo
    }

    enum State {
        case loading
        case loaded(Todo)
    }

    var statechanged: ((State) -> Void)?

    private(set) var state: State = .loading {
        didSet {
            statechanged?(state)
        }
    }

    func changeState(_ action: Action) {
        switch action {
        case .todo:
            let url = URL(string: "https://jsonplaceholder.typicode.com/todos/13")!
            TodoService.shared.fetch(from: url) { data in
                switch data {
                case .success(let todo):
                    self.state = .loaded(todo)
                case .failure(let err):
                    print("\(err.localizedDescription)")
                }
            }
        }
    }
}
