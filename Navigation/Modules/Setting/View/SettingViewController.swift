//
//  SettingViewController.swift
//  Navigation
//
//  Created by Dima Skvortsov on 04.08.2022.
//

import UIKit

enum SettingType {
    case staticCell(model: SettingOption)
    case switchCell(model: SettingSwitchOption)
}

struct SettingOption {
    let title: String
    let handler: (() -> Void)
}

struct SettingSwitchOption {
    let title: String
    let isOn: Bool
}

struct UserSettings: Codable {
    var sortedDocument: Bool
}

// MARK: - SettingViewController
class SettingViewController: UIViewController {

    var models: [SettingType] = []
    private var userSettings: UserSettings?

    private lazy var table: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifer)
        table.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.identifer)
        table.frame = view.bounds
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = .white
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Настройки"
        navigationController?.navigationBar.prefersLargeTitles = true
        configureSettings()
        configureUI()
        configureModel()
    }

    private func configureSettings() {
        if let data = UserDefaults.standard.data(forKey: "userSettings"), let settingsData = try? JSONDecoder().decode(UserSettings.self, from: data) {
            userSettings = settingsData
        }
    }

    private func configureModel() {
        models = [
            .switchCell(
                model: SettingSwitchOption(title: "Сортировка", isOn: userSettings?.sortedDocument ?? true)),
            .staticCell(
                model: SettingOption(title: "Поменять пароль") {
                    self.present(SettingChangePasswordViewController(), animated: true)
                }),
        ]
    }

    private func configureUI() {
        view.addSubview(table)
    }
}

// MARK: - UITableViewDataSource
extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        switch model.self {
        case .staticCell(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifer, for: indexPath) as? SettingTableViewCell else {
                return UITableViewCell()
            }
            cell.congigure(with: model)
            return cell
        case .switchCell(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifer, for: indexPath) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            cell.congigure(with: model)
            cell.switchHandler = { [weak self] toggle in
                switch toggle {
                case true:
                    let newUserSettings = UserSettings(sortedDocument: true)
                    if let data = try? JSONEncoder().encode(newUserSettings) {
                        UserDefaults.standard.set(data, forKey: "userSettings")
                        self?.userSettings?.sortedDocument = true
                    }
                case false:
                    let newUserSettings = UserSettings(sortedDocument: false)
                    if let data = try? JSONEncoder().encode(newUserSettings) {
                        UserDefaults.standard.set(data, forKey: "userSettings")
                        self?.userSettings?.sortedDocument = false
                    }
                }
            }
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = models[indexPath.row]
        switch type.self {
        case .staticCell(let model):
            model.handler()
        case .switchCell(_):
            break
        }
    }
}
