//
//  FeedViewController.swift
//  Navigation
//
//  Created by mitr on 03.03.2022.
//

import UIKit

class FeedViewController: UIViewController {
    
    let button: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        button.backgroundColor = .systemBlue
        button.setTitle("Смотреть запись", for: .normal)
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addButton()
    }
    
    private func addButton() {
        button.center = view.center
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
