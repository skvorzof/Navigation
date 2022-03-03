//
//  PostViewController.swift
//  Navigation
//
//  Created by mitr on 03.03.2022.
//

import UIKit

class PostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hue: 0.5, saturation: 0.07, brightness: 1, alpha: 1.0)
        
        if let rightBarButton = navigationItem.rightBarButtonItem {
            rightBarButton.target = self
            rightBarButton.action = #selector(info)
        }
    }
    
    @objc func info() {
        let infoVC = InfoViewController()
        let nc = UINavigationController(rootViewController: infoVC)
        present(nc, animated: true, completion: nil)
    }
}
