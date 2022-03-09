//
//  ProfileViewController.swift
//  Navigation
//
//  Created by mitr on 03.03.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let profileHeaderView = ProfileHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 209.0/255.0, green: 209.0/255.0, blue: 214.0/255.0, alpha: 1.0)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        profileHeaderView.frame = self.view.frame
        view.addSubview(profileHeaderView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .white
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
