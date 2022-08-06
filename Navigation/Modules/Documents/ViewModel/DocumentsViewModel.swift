//
//  DocumentsViewModel.swift
//  Navigation
//
//  Created by mitr on 26.07.2022.
//

import Foundation
import UIKit

final class DocumentsViewModel {

    enum Action {
        case tableInit
    }

    enum State {
        case initial
        case loaded([Document])
    }
    private let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

    var documents: [Document] = []

    var changedState: ((State) -> Void)?

    private(set) var state: State = .initial {
        didSet {
            changedState?(state)
        }
    }

    private func configureSetiings() {
        if let data = UserDefaults.standard.data(forKey: "userSettings"), let settingsData = try? JSONDecoder().decode(UserSettings.self, from: data) {
            if settingsData.sortedDocument {
                documents.sort {
                    $0.url.lastPathComponent < $1.url.lastPathComponent
                }
            }
        }
    }

    func stateChange(_ action: Action) {
        switch action {
        case .tableInit:
            state = .initial
            DocumentService.shared.contentsOfDirectory(url: documentsUrl) { [weak self] result in
                switch result {
                case .success(let model):
                    self?.documents = model
                    self?.configureSetiings()
                    self?.state = .loaded(model)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

}
