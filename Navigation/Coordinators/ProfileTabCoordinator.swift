//
//  FirstTabCoordinator.swift
//  Navigation
//
//  Created by mitr on 15.06.2022.
//

import Foundation
import UIKit

final class ProfileTabCoordinator: NSObject, CoordinatorProtocol {
    
    var rootViewController: UINavigationController
    private let loginViewController = LoginViewController()
    
    
    override init() {
        rootViewController = UINavigationController()
        super.init()
    }
    
    
    func start() {
        rootViewController.setViewControllers([loginViewController], animated: false)
    }
}
