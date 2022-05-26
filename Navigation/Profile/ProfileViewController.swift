//
//  ProfileViewController.swift
//  Navigation
//
//  Created by mitr on 03.03.2022.
//

import UIKit
import SnapKit
import StorageService

class ProfileViewController: UIViewController {
    
    let headerView = ProfileHeaderView()
    let posts = PostModel.makePostModel()
    let photos = PhotoModel.makePhotoModel()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset.bottom = -40
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: PhotoTableViewCell.identifier)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        return tableView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "xmark.circle", withConfiguration: config), for: .normal)
        button.alpha = 0
        button.addTarget(self, action: #selector(animateAvatarOut), for: .touchUpInside)
        return button
    }()
    
    private lazy var avatar = headerView.avatarImageView
    
    private var xAvatar = NSLayoutConstraint()
    private var yAvatar = NSLayoutConstraint()
    private var widthAvatar = NSLayoutConstraint()
    private var heightAvatar = NSLayoutConstraint()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setupGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    
    
    private func layout() {
        [tableView, overlayView, avatar, closeButton].forEach({ view.addSubview($0)})
        
        tableView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        overlayView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.trailing.equalTo(view).offset(-16)
        }
        
        xAvatar = avatar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        yAvatar = avatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        widthAvatar = avatar.widthAnchor.constraint(equalToConstant: 110)
        heightAvatar = avatar.heightAnchor.constraint(equalToConstant: 110)

        NSLayoutConstraint.activate([
            xAvatar,
            yAvatar,
            widthAvatar,
            heightAvatar
        ])
    }
    
    
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(animateAvatarIn))
        avatar.addGestureRecognizer(tapGesture)
    }
    
    @objc private func animateAvatarIn() {
        view.layoutIfNeeded()
        
        NSLayoutConstraint.deactivate([xAvatar, yAvatar, widthAvatar, heightAvatar])

        xAvatar = avatar.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        yAvatar = avatar.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        widthAvatar = avatar.widthAnchor.constraint(equalTo: view.widthAnchor)
        heightAvatar = avatar.heightAnchor.constraint(equalTo: view.widthAnchor)
        
        NSLayoutConstraint.activate([xAvatar, yAvatar, widthAvatar, heightAvatar])
        
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            self.tabBarController?.tabBar.isHidden = true
            self.overlayView.alpha = 0.70
            self.avatar.layer.borderWidth = 0
            self.avatar.contentMode = .scaleToFill
            self.avatar.layer.cornerRadius = 0
            self.view.layoutIfNeeded()
        }, completion: {_ in
            UIView.animate(withDuration: 0.3, delay: 0, animations: {
                self.closeButton.transform = CGAffineTransform(rotationAngle: 165)
                self.closeButton.alpha = 1
            })
        })

    }
    
    @objc private func animateAvatarOut() {
        view.layoutIfNeeded()
        
        NSLayoutConstraint.deactivate([xAvatar, yAvatar, widthAvatar, heightAvatar])
        
        widthAvatar = avatar.widthAnchor.constraint(equalToConstant: 110)
        heightAvatar = avatar.heightAnchor.constraint(equalToConstant: 110)
        yAvatar = avatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        xAvatar = avatar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        
        NSLayoutConstraint.activate([xAvatar, yAvatar, widthAvatar, heightAvatar])
        
        UIView.animate(withDuration: 0.3, delay: 0, animations: {
            self.closeButton.transform = .identity
            self.closeButton.alpha = 0
            self.avatar.layer.borderWidth = 3
            self.avatar.layer.cornerRadius = 55
            self.view.layoutIfNeeded()
        }, completion: {_ in
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.closeButton.alpha = 0
                self.overlayView.alpha = 0
                self.tabBarController?.tabBar.isHidden = false
            })
        })

    }
}



extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: PhotoTableViewCell.identifier,
                for: indexPath) as! PhotoTableViewCell
            cell.buttonArrow.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
            cell.delegateNavigation = {
                let photosVC = PhotosViewController()
                self.navigationController?.pushViewController(photosVC, animated: true)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: PostTableViewCell.identifier,
                for: indexPath) as! PostTableViewCell
            cell.setupCell(model: posts[indexPath.row])
            return cell
        }
    }
    
    @objc private func onButtonTap() {
        let photosVC = PhotosViewController()
        navigationController?.pushViewController(photosVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return posts.count
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
}



extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 240
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let photosVC = PhotosViewController()
            navigationController?.pushViewController(photosVC, animated: true)
        default:
            let postVC = PostViewController()
            postVC.title = posts[indexPath.row].title
            postVC.setupPost(model: posts[indexPath.row])
            navigationController?.pushViewController(postVC, animated: true)
        }
    }
}
