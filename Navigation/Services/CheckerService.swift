//
//  CheckerService.swift
//  Navigation
//
//  Created by mitr on 21.07.2022.
//

import FirebaseAuth
import Foundation

// MARK: - CheckerServiceProtocol
protocol CheckerServiceProtocol {
    func checkCredentials(email: String, password: String)

    func signUp(email: String, password: String)
}

// MARK: - CheckerService
final class CheckerService: CheckerServiceProtocol {

    static let shared = CheckerService()

    var completionMessage: ((_ errorMessage: String) -> Void)?

    private init() {}

    func checkCredentials(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }

            guard error == nil else {
                if let completion = self.completionMessage {
                    completion("Создать новый аккаунт?")
                }
                return
            }

            if let error = error {
                if let completion = self.completionMessage {
                    completion(error.localizedDescription)
                }
            }
            

        }
    }

    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard error == nil else {
                if let completion = self.completionMessage {
                    if let error = error {
                        completion(error.localizedDescription)
                    }
                }
                return
            }
        }

    }

}
