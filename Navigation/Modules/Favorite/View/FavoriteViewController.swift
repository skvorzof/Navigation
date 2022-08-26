//
//  FavoriteViewController.swift
//  Navigation
//
//  Created by Dima Skvortsov on 15.08.2022.
//

import CoreData
import UIKit

class FavoriteViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private var fetchedResultsController: NSFetchedResultsController<Favorite>?

    private lazy var table: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupFetchedResultsController(for: context, filter: nil)
        fetchFavorites()
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

    private func setupFetchedResultsController(for context: NSManagedObjectContext, filter: String?) {
        let request = Favorite.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]

        if let filter = filter {
            request.predicate = NSPredicate(format: "(author contains[cd] %@)", filter)
        }

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController?.delegate = self
    }

    @objc
    private func didTapButtonFilter() {
        let alertController = UIAlertController(title: "Показать только  от автора", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "например: dmtr"
        }
        let continueAction = UIAlertAction(title: "Готово", style: .default) { [weak self] _ in
            guard let textFields = alertController.textFields else { return }
            if let author = textFields[0].text, !author.isEmpty {
                self?.setupFetchedResultsController(for: self!.context, filter: author)
                self?.fetchFavorites()
            }
        }
        alertController.addAction(continueAction)
        self.present(alertController, animated: true)
    }

    @objc
    private func didTapButtonFilterClear() {
        setupFetchedResultsController(for: context, filter: nil)
        fetchFavorites()
    }

    private func fetchFavorites() {
        do {
            try fetchedResultsController?.performFetch()
            table.reloadData()
        } catch {
            fatalError("Can`t fetch from bd")
        }
    }
}

// MARK: - UITableViewDataSource
extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else { return 0 }
        return sections[section].numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.identifier, for: indexPath) as? FavoriteCell else {
            return UITableViewCell()
        }

        guard let favoriteModel = fetchedResultsController?.object(at: indexPath) else { return UITableViewCell() }
        let model = Post(favorite: favoriteModel)
        cell.setup(model: model)
        return cell
    }
}

extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let favoriteModel = fetchedResultsController?.object(at: indexPath) else { return }
        let model = Post(favorite: favoriteModel)
        let vc = PostViewController(viewModel: model)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension FavoriteViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}

extension FavoriteViewController {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completion) in
            guard let self = self else { return }

            guard let removeModel = self.fetchedResultsController?.object(at: indexPath) else { return }

            do {
                self.context.delete(removeModel)
                try self.context.save()
            } catch {
                fatalError("Delete context error")
            }

        }
        deleteAction.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension FavoriteViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        table.beginUpdates()
    }

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            table.insertRows(at: [newIndexPath], with: .right)
        case .delete:
            guard let indexPath = indexPath else { return }
            table.deleteRows(at: [indexPath], with: .left)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            table.deleteRows(at: [indexPath], with: .left)
            table.insertRows(at: [newIndexPath], with: .right)
        case .update:
            guard let indexPath = indexPath else { return }
            table.reloadRows(at: [indexPath], with: .left)
        @unknown default:
            fatalError()
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        table.endUpdates()
    }
}
