//
//  ProfileViewController.swift
//  Navigation
//
//  Created by mitr on 03.03.2022.
//

import FirebaseAuth
import SnapKit
import StorageService
import UIKit

class ProfileViewController: UIViewController {

    private let viewModel: PostViewModel
    private let coordinator: ProfileFlowCoorinator
    private let databaseCoordinator: DatabaseCoordinatable

    private var posts = [Post]()

    let photos = Photo().fetchPhotos()
    let headerView = ProfileHeaderView()
    private lazy var avatar = headerView.avatarImageView

    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.alpha = 0.0
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset.bottom = -40
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: PhotoTableViewCell.identifier)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        return tableView
    }()

    init(
        viewModel: PostViewModel,
        coordinator: ProfileFlowCoorinator,
        databaseCoordinator: DatabaseCoordinatable
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        self.databaseCoordinator = databaseCoordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //        Auth.auth().addStateDidChangeListener { auth, user in
        //            if user == nil {
        //                self.coordinator.showLogin(nc: self.navigationController, coordinator: self.coordinator)
        //            }
        //        }

        layout()
        setupViewModel()
        viewModel.changeState(.viewIsReady)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    private func setupViewModel() {
        viewModel.stateChanged = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .initial:
                print("Initial")
            case .loading:
                self.activityIndicator.startAnimating()
            case .loaded(let posts):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.posts = posts
                    self.tableView.alpha = 1.0
                    self.tableView.reloadData()
                }
            case .error:
                ()
            }
        }
    }

    private func savePostInDatabase(_ filterPost: Post, index: Int, using data: [Post]) {
        databaseCoordinator.create(Favorite.self, keyedValues: [filterPost.keyedValues]) { result in
            switch result {
            case .success(_):
                var newData = data
                newData[index] = filterPost

                let userInfo = ["favorite": filterPost]
                NotificationCenter.default.post(name: .wasLikedPost, object: nil, userInfo: userInfo)
            case .failure(let error):
                print("Error \(error)")
            }
        }
    }

    private func removePostFromDatabase(_ filterPost: Post, index: Int, using data: [Post]) {
        let predicate = NSPredicate(format: "title == %@", filterPost.title)
        databaseCoordinator.delete(Favorite.self, predicate: predicate) { result in
            switch result {
            case .success(_):
                var newData = data
                newData[index] = filterPost

                let userInfo = ["favorite": filterPost]
                NotificationCenter.default.post(name: .wasLikedPost, object: nil, userInfo: userInfo)
            case .failure(let error):
                print("Error \(error)")
            }
        }
    }

    private func layout() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

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
            let cell =
                tableView.dequeueReusableCell(
                    withIdentifier: PhotoTableViewCell.identifier,
                    for: indexPath) as! PhotoTableViewCell
            cell.buttonArrow.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
            cell.delegateNavigation = {
                let photosVC = PhotosViewController()
                self.navigationController?.pushViewController(photosVC, animated: true)
            }
            return cell
        default:
            let cell =
                tableView.dequeueReusableCell(
                    withIdentifier: PostTableViewCell.identifier,
                    for: indexPath) as! PostTableViewCell
            let post = posts[indexPath.row]
            let model = PostTableViewCell.ViewModel(
                title: post.title,
                author: post.author,
                descriptions: post.descriptions,
                image: post.image,
                likes: post.likes,
                views: post.views,
                isFavorite: post.isFavorite)
            cell.delegate = self
            cell.setup(with: model)
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
            break
        //            let postVC = PostViewController()
        //            postVC.title = posts[indexPath.row].title
        //            postVC.setupPost(model: posts[indexPath.row])
        //            navigationController?.pushViewController(postVC, animated: true)
        }
    }
}

extension ProfileViewController: PostTableViewCellDelefate {
    func wasFavoritePost(with title: String) {
        guard var filterPost = posts.first(where: { $0.title == title }),
            let index = posts.firstIndex(where: { $0.title == title })
        else { return }

        filterPost.isFavorite.toggle()
        filterPost.isFavorite
            ? self.savePostInDatabase(filterPost, index: index, using: posts)
            : self.removePostFromDatabase(filterPost, index: index, using: posts)
    }
}
