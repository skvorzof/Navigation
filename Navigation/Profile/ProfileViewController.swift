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
    
    let posts = PostModel.makePostModel()
    let photos = PhotoModel.makePhotoModel()
    let headerView = ProfileHeaderView()
    private lazy var avatar = headerView.avatarImageView
    private var userService: UserService
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset.bottom = -40
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: PhotoTableViewCell.identifier)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        return tableView
    }()
        


    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    
    
    init(userService: UserService, loginName: String) {
        self.userService = userService
        super.init(nibName: nil, bundle: nil)
        guard let user = self.userService.userService(userName: loginName) else { return }
        headerView.fullNameLabel.text = user.fullName
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func layout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
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
