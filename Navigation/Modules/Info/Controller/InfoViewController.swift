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

    private lazy var table: UITableView = {
        let table = UITableView()
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
        let button = CustomButton(title: "Предупреждение", titleColor: .white, backColor: .red)
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hue: 0.3, saturation: 0.3, brightness: 1, alpha: 1.0)
        title = "Информация"

        setupUI()
        addButton()
        setupModel()
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
            title: "Внимание",
            message: "Вы уверены?",
            preferredStyle: .alert)

        let cancelAction = UIAlertAction(
            title: "Нет",
            style: .cancel,
            handler: { _ in
                print("Не уверен")
            })
        alert.addAction(cancelAction)

        let deletelAction = UIAlertAction(
            title: "Да",
            style: .destructive,
            handler: { _ in
                print("Уверен")
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

    }

    private func setupModel() {
        viewModel.todoTitle.bind({ [titleLabel] title in
            DispatchQueue.main.async {
                titleLabel.text = "Todo title: \(title)"
            }
        })
        viewModel.statechanged = { [table, viewModel, orbitalPeriodLabel] state in
            switch state {
            case .loaded:
                DispatchQueue.main.async {
                    orbitalPeriodLabel.text = "orbitalPeriod: \(viewModel.planetModel[0].orbitalPeriod)"
                    table.reloadData()
                }
            }
        }
        
        viewModel.getTodo()
        
        viewModel.changeState(.initModel)
        viewModel.changeState(.initTable)
        viewModel.getResident()
        
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
        content.text = viewModel.residents[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
}
