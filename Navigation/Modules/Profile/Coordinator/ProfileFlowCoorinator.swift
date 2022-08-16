//
//  ProfileFlowCoorinator.swift
//  Navigation
//
//  Created by mitr on 22.07.2022.
//

import Foundation
import UIKit

final class ProfileFlowCoorinator {
    
    func showLogin(nc: UINavigationController?, coordinator: ProfileFlowCoorinator) {
        let vc = LoginViewController()
        nc?.pushViewController(vc, animated: true)
    }
    
    func showProfile(nc: UINavigationController?, coordinator: ProfileFlowCoorinator) {
        let viewModel = PostViewModel()
        let databaseCoordinator = MigrationService.shared.coreDataCoordinator
        let vc = ProfileViewController(viewModel: viewModel, coordinator: coordinator, databaseCoordinator: databaseCoordinator)
        nc?.pushViewController(vc, animated: true)
    }
}
