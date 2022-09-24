//
//  InfoViewController.swift
//  Navigation
//
//  Created by mitr on 03.03.2022.
//

import SnapKit
import UIKit

// MARK: - InfoViewController
class InfoViewController: UIViewController {

    private let viewModel = InfoViewModel()

    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    private lazy var table: UITableView = {
        let table = UITableView()
        table.alpha = 0
        table.dataSource = self
        return table
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    private let orbitalPeriodLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var button: CustomButton = {
        let button = CustomButton(title: "warning".localized(), titleColor: .white, backColor: .red)
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "info".localized()

        setupUI()
        addButton()
        setupModel()
        activityIndicator.startAnimating()
    }

    private func addButton() {
        button.center = view.center
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-23)
        }
    }

    @objc private func tap(sender: UIButton) {
        let alert = UIAlertController(
            title: "attention".localized(),
            message: "areYouSure?".localized(),
            preferredStyle: .alert)

        let cancelAction = UIAlertAction(
            title: "no".localized(),
            style: .cancel,
            handler: { _ in
                print("notSure".localized())
            })
        alert.addAction(cancelAction)

        let deletelAction = UIAlertAction(
            title: "yes".localized(),
            style: .destructive,
            handler: { _ in
                print("sure".localized())
            })
        alert.addAction(deletelAction)
        present(alert, animated: true, completion: nil)
    }

    @objc private func close(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    private func setupUI() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
        }

        view.addSubview(orbitalPeriodLabel)
        orbitalPeriodLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
        }

        view.addSubview(table)
        table.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-120)
            $0.top.equalTo(orbitalPeriodLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

    }

    private func setupModel() {
        viewModel.todoTitle.bind({ [titleLabel] title in
            DispatchQueue.main.async {
                titleLabel.text = "Todo title: \(title)"
            }
        })
        viewModel.statechanged = { [table, viewModel, orbitalPeriodLabel, activityIndicator] state in
            switch state {
            case .loaded:
                DispatchQueue.main.async {
                    orbitalPeriodLabel.text = "orbitalPeriod: \(viewModel.planetModel[0].orbitalPeriod)"
                    activityIndicator.stopAnimating()
                    table.alpha = 1
                    table.reloadData()
                }
            }
        }

        viewModel.getTodo()

        viewModel.changeState(.initModel)
        viewModel.changeState(.initTable)

    }
}

// MARK: - InfoViewController: UITableViewDataSource
extension InfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.residents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        var content: UIListContentConfiguration = cell.defaultContentConfiguration()
        content.text = viewModel.residents[indexPath.row].name
        cell.contentConfiguration = content
        return cell
    }
}
