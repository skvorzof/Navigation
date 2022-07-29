//
//  DocumentsViewController.swift
//  Navigation
//
//  Created by mitr on 26.07.2022.
//

import SnapKit
import UIKit

// MARK: - DocumentsViewController
class DocumentsViewController: UIViewController {

    private let viewModel: DocumentsViewModel
    private let coordinator: DocumentsFlowCoordinator


    private lazy var folderIconBar = UIBarButtonItem(
        image: UIImage(systemName: "folder.badge.plus"),
        style: .plain,
        target: self,
        action: #selector(didTapFolderIcon))

    private lazy var fileIconBar = UIBarButtonItem(
        image: UIImage(systemName: "plus"),
        style: .plain,
        target: self,
        action: #selector(didTapFileIcon))

    private lazy var table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.dataSource = self
        table.delegate = self
        return table
    }()

    init(viewModel: DocumentsViewModel, coordinator: DocumentsFlowCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems = [fileIconBar, folderIconBar]

        setupUI()
        setupModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.stateChange(.tableInit)
    }

    // MARK: - didTapFolderIcon
    @objc
    private func didTapFolderIcon() {
        let alert = UIAlertController(title: "Создать новую папку", message: nil, preferredStyle: .alert)
        alert.addTextField { nameField in
            nameField.placeholder = "Имя папки"
        }

        let confirm = UIAlertAction(title: "Создать", style: .default) {[viewModel] _ in

            if let textField = alert.textFields?.first, let text = textField.text {
                DocumentService.shared.createDirectory(title: text)
                viewModel.stateChange(.tableInit)
            }
        }

        let cancel = UIAlertAction(title: "Отмена", style: .cancel)

        alert.addAction(confirm)
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)

    }

    // MARK: - didTapFileIcon
    @objc
    private func didTapFileIcon() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }

    private func setupModel() {
        viewModel.changedState = {[table] state in
            switch state {
            case .initial:
                break
            case .loaded(_):
                DispatchQueue.main.async {
                    table.reloadData()
                }
            }
        }
    }

    // MARK: - setupUI
    private func setupUI() {
        view.addSubview(table)

        table.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }

}

// MARK: - DocumentsViewController: UITableViewDataSource
extension DocumentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.documents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if viewModel.documents[indexPath.row].type == .folder {
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.accessoryType = .none
        }

        var content: UIListContentConfiguration = cell.defaultContentConfiguration()
        content.text = viewModel.documents[indexPath.row].url.lastPathComponent
        cell.contentConfiguration = content
        return cell
    }

}

// MARK: - DocumentsViewController: UITableViewDelegate
extension DocumentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.documents[indexPath.row].type == .folder {
            coordinator.showDetail(nc: navigationController, coordinator: coordinator)
            print(viewModel.documents[indexPath.row].url.absoluteURL)
        } else {
            let url = viewModel.documents[indexPath.row].url.path
            let vc = DocumentImageViewController(url: url)
            navigationController?.present(vc, animated: true)
        }
    }
}

// MARK: - DocumentsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension DocumentsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            DocumentService.shared.createFile(image: image)
            viewModel.stateChange(.tableInit)
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
