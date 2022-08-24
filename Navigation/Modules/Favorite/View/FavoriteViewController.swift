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

    private lazy var addFilterIconBar = UIBarButtonItem(
        image: UIImage(systemName: "magnifyingglass"),
        style: .plain,
        target: self,
        action: #selector(didTapButtonFilter))

    private lazy var clearFilterIconBar = UIBarButtonItem(
        image: UIImage(systemName: "xmark"),
        style: .plain,
        target: self,
        action: #selector(didTapButtonFilterClear))

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
    }

    private func setupView() {
        navigationItem.rightBarButtonItems = [clearFilterIconBar, addFilterIconBar]
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        view.addSubview(table)

        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    @objc
    private func didTapButtonFilter() {
        let alertController = UIAlertController(title: "Показать только  от автора", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "например: dmtr"
        }
        let continueAction = UIAlertAction(title: "Готово", style: .default) { [weak alertController, databaseCoordinator] _ in
            guard let textFields = alertController?.textFields else { return }
            if let author = textFields[0].text, !author.isEmpty {
                let perdicate = NSPredicate(format: "author == %@", author)
                databaseCoordinator.fetch(
                    Favorite.self,
                    predicate: perdicate
                ) { result in
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
        }
        alertController.addAction(continueAction)
        self.present(alertController, animated: true)
    }

    @objc
    private func didTapButtonFilterClear() {
        fetchFavoritesFromDatabase()
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

extension FavoriteViewController {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch state {
        case .hasModel(let model):
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completion) in
                guard let self = self else { return }
                var newModel = model
                let deletedFavorite = model[indexPath.row]
                newModel.remove(at: indexPath.row)
                self.state = .hasModel(model: newModel)

                self.table.beginUpdates()
                self.table.deleteRows(at: [indexPath], with: .fade)
                self.table.endUpdates()

                let perdicate = NSPredicate(format: "title == %@", deletedFavorite.title)
                self.databaseCoordinator.delete(
                    Favorite.self,
                    predicate: perdicate
                ) { result in
                    switch result {
                    case .success(_):
                        break
                    case .failure(let error):
                        print("😱 \(error.localizedDescription)")
                    }
                }

            }
            deleteAction.image = UIImage(systemName: "trash")
            return UISwipeActionsConfiguration(actions: [deleteAction])
        case .empty:
            return nil
        }
    }
}
