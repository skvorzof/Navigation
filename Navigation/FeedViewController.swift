//
//  FeedViewController.swift
//  Navigation
//
//  Created by mitr on 03.03.2022.
//

import UIKit

class FeedViewController: UIViewController {
    
    struct Post {
        let title: String
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        button.center = view.center
        button.backgroundColor = .systemBlue
        button.setTitle("Смотреть запись", for: .normal)
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        
        view.addSubview(button)
    }
    
    @objc private func tap(sender: UIButton) {
        let post = Post(title: "Запись")
        let postVC = PostViewController()
        postVC.title = post.title
        postVC.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "info.circle"),
            style: .done,
            target: self,
            action: nil)
        
        navigationController?.pushViewController(postVC, animated: true)
    }
}
