//
//  PostViewModel.swift
//  Navigation
//
//  Created by mitr on 17.06.2022.
//

import UIKit

final class PostViewModel {
    
    enum Action {
        case viewIsReady
        case cellDidTap
    }
    
    enum State {
        case initial
        case loading
        case loaded([Post])
        case error
    }
    
    private let postService = PostService()
    
    var stateChanged: ((State) -> Void)?
    
    private(set) var state: State = .initial {
        didSet {
            stateChanged?(state)
        }
    }
    
    func changeState(_ action: Action) {
        switch action {
        case .viewIsReady:
            state = .loading
            postService.fetchPosts { [weak self] result in
                switch result {
                case .success(let model):
                    self?.state = .loaded(model)
                case .failure(let error):
                    self?.handleError(postError: error)
                }
            }
        case .cellDidTap:
            print("cell did tapped")
        }
    }
    
    private func handleError(postError: PostError) {
        switch postError {
        case .empty:
            print("Постов нет")
        }
    }
}
