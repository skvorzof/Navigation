//
//  InfoViewController.swift
//  Navigation
//
//  Created by mitr on 03.03.2022.
//

import SnapKit
import UIKit

class InfoViewController: UIViewController {

    private let viewModel = InfoViewModel()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
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
            $0.center.equalToSuperview()
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
            $0.top.equalTo(view.snp.top).inset(200)
        }
    }

    private func setupModel() {
        viewModel.todoTitle.bind({ [titleLabel] title in
            DispatchQueue.main.async {
                titleLabel.text = title
            }
        })

        viewModel.get()
    }
}
