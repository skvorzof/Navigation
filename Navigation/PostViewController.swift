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
        view.backgroundColor = .white
        layout()
        
        if let rightBarButton = navigationItem.rightBarButtonItem {
            rightBarButton.target = self
            rightBarButton.action = #selector(info)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc private func info() {
        let infoVC = InfoViewController()
        let nc = UINavigationController(rootViewController: infoVC)
        present(nc, animated: true, completion: nil)
    }
    
    private let postTitle: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 2
        return $0
    }(UILabel())
    
    private let postImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .black
        return $0
    }(UIImageView())
    
    
    func setupPost(model: PostModel) {
        postTitle.text = model.title
        postImage.image = UIImage(named: model.image)
    }
    
    
    private func layout() {
        let offset: CGFloat = 16
        [postTitle, postImage].forEach({view.addSubview($0)})

        NSLayoutConstraint.activate([
            postTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: offset),
            postTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset),
            postTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -offset),
            
            postImage.widthAnchor.constraint(equalToConstant: view.frame.width),
            postImage.heightAnchor.constraint(equalToConstant: view.frame.width),
            postImage.topAnchor.constraint(equalTo: postTitle.bottomAnchor, constant: offset),
            postImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
