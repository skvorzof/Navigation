//
//  LocalAuthorizationService.swift
//  Navigation
//
//  Created by Dima Skvortsov on 31.10.2022.
//

import Foundation
import LocalAuthentication

final class LocalAuthorizationService {

    static let shared = LocalAuthorizationService()
    private init() {}

    var context = LAContext()
    let policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics
    var canUseBiometrics = false
    var error: NSError?

    func getTypeAuthorize(complition: @escaping (LABiometryType) -> Void) {
        let _ = context.canEvaluatePolicy(policy, error: nil)
        complition(context.biometryType)
    }

    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool) -> Void) {

        canUseBiometrics = context.canEvaluatePolicy(policy, error: &error)

        if let error = error {
            print(error)
        } else {
            guard canUseBiometrics else { return }

            context.evaluatePolicy(
                policy,
                localizedReason: "Авторизируйтесь для входа"
            ) { success, error in
                if let error = error {
                    print("Попробуйте другой способ, \(error.localizedDescription)")
                    return
                }
                authorizationFinished(success)
            }

        }
    }
}
