//
//  PostViewController.swift
//  Navigation
//
//  Created by mitr on 03.03.2022.
//

import UIKit
import StorageService

class PostViewController: UIViewController {
        
    var viewModel: Post?
    
    init(viewModel: Post) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = viewModel?.title
        layout()
        setupPost(model: viewModel!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
//    @objc private func info() {
//        let infoVC = InfoViewController()
//        let nc = UINavigationController(rootViewController: infoVC)
//        present(nc, animated: true, completion: nil)
//    }
    
    private let postTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    private let postImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        return imageView
    }()
    
    
    func setupPost(model: Post) {
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
