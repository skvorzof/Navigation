//
//  MyLoginFactory.swift
//  Navigation
//
//  Created by mitr on 31.05.2022.
//

final class MyLoginFactory: LoginFactory {
    func makeLoginFactory() -> LoginInspector {
        return LoginInspector()
    }
}
