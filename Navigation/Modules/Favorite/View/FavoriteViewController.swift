//
//  FavoriteViewController.swift
//  Navigation
//
//  Created by Dima Skvortsov on 15.08.2022.
//

import UIKit

class FavoriteViewController: UIViewController {

    private enum State {
        case empty
        case hasModel(model: [Post])
    }

    private var state: State = .empty

    private let databaseCoordinator: DatabaseCoordinatable

    private lazy var table: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "favoriteCell")
        table.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.identifier)
        table.dataSource = self
        table.delegate = self
        return table
    }()

    init(databaseCoordinator: DatabaseCoordinatable) {
        self.databaseCoordinator = databaseCoordinator
        super.init(nibName: nil, bundle: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(wasAddedFavorites(_:)), name: .wasLikedPost, object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchFavoritesFromDatabase()
        //        databaseCoordinator.deleteAll(Favorite.self) { result in
        //            switch result {
        //            case .success(_):
        //                print("OK")
        //            case .failure(_):
        //                break
        //            }
        //        }
    }

    private func setupView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        view.addSubview(table)
        
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func fetchFavoritesFromDatabase() {
        databaseCoordinator.fetchAll(Favorite.self) { result in
            switch result {
            case .success(let favoriteModels):
                let favorites = favoriteModels.map {
                    Post(favorite: $0)
                }
                self.state = favorites.isEmpty ? .empty : .hasModel(model: favorites)
                self.table.reloadData()
            case .failure(let error):
                print("Error \(error.localizedDescription)")
                self.state = .empty
            }
        }
    }

    @objc
    private func wasAddedFavorites(_ notification: NSNotification) {
        guard self.isViewLoaded else { return }

        if let favorite = notification.userInfo?["favorite"] as? Post {
            switch state {
            case .empty:
                if favorite.isFavorite {
                    let model = [favorite]
                    self.state = .hasModel(model: model)
                    self.table.beginUpdates()
                    self.table.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
                    self.table.endUpdates()
                }
            case .hasModel(let model):
                var newModel = model
                if favorite.isFavorite {
                    newModel.append(favorite)
                    self.state = .hasModel(model: newModel)
                    let lastIndex = newModel.count - 1
                    self.table.beginUpdates()
                    self.table.insertRows(at: [IndexPath(row: lastIndex, section: 0)], with: .fade)
                    self.table.endUpdates()
                } else {
                    guard let index = model.firstIndex(where: { $0 == favorite }) else { return }

                    newModel.remove(at: index)
                    self.state = .hasModel(model: newModel)
                    self.table.beginUpdates()
                    self.table.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                    self.table.endUpdates()
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .empty:
            return 0
        case .hasModel(let model):
            return model.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch state {
        case .empty:
            let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)
            return cell
        case .hasModel(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.identifier, for: indexPath) as? FavoriteCell
            let favorite = model[indexPath.row]
            cell?.setup(model: favorite)
            return cell!
        }
    }
}

extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch state {
        case .hasModel(let model):
            let model = model[indexPath.row]
            let vc = PostViewController(viewModel: model)
            navigationController?.pushViewController(vc, animated: true)
        case .empty:
            break
        }
    }
}

extension FavoriteViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
