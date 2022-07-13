//
//  InfoCoordinator.swift
//  Navigation
//
//  Created by mitr on 13.07.2022.
//

import UIKit

// MARK: - InfoCoordinator
final class InfoCoordinator {
    func showInfo(nc: UINavigationController?, coordinator: InfoCoordinator) {
        let vc = InfoViewController(coordinator: coordinator)
        nc?.pushViewController(vc, animated: true)
    }
}
