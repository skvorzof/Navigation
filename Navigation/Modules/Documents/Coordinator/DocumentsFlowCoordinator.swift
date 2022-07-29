//
//  DocumentsFlowCoordinator.swift
//  Navigation
//
//  Created by mitr on 26.07.2022.
//

import UIKit

// MARK: - DocumentsFlowCoordinator
final class DocumentsFlowCoordinator {
    
    func showDetail(nc: UINavigationController?, coordinator: DocumentsFlowCoordinator) {
        let vm = DocumentsViewModel()
        let vc = DocumentsViewController(viewModel: vm, coordinator: coordinator)
        nc?.pushViewController(vc, animated: true)
    }
}
