//
//  TestUserService.swift
//  Navigation
//
//  Created by mitr on 30.05.2022.
//

import UIKit

final class TestUserService: UserService {
    let user = User(fullName: "Тестовый пользователь", avatar: "testAvatar", status: "testUser")
    
    func userService(userName: String) -> User? {
        return user
    }
}
