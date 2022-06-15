//
//  FirstTabCoordinator.swift
//  Navigation
//
//  Created by mitr on 15.06.2022.
//

import Foundation
import UIKit

final class ProfileTabCoordinator: CoordinatorProtocol {
    
    let rootViewController = UINavigationController()
    private let loginViewController = LoginViewController()
    private let myLoginFactory = MyLoginFactory()
    
    init() {
        loginViewController.delegate = myLoginFactory.makeLoginFactory()
    }
    

    func start() {
        rootViewController.setViewControllers([loginViewController], animated: false)
    }
}
