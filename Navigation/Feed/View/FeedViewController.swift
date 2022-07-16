//
//  FeedViewController.swift
//  Navigation
//
//  Created by mitr on 03.03.2022.
//

import UIKit

class FeedViewController: UIViewController {

    private let viewModel: FeedViewModel
    private let coordinator: FeedFlowCoordinator

    private let passwordModel = PasswordModel()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    private lazy var textField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Введите пароль (q)")
        textField.backgroundColor = .white
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.textColor = .black
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.shadowColor = UIColor.black.cgColor
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 2))
        textField.leftView = leftView
        textField.leftViewMode = .always
        return textField
    }()

    private lazy var checkButton: CustomButton = {
        let button = CustomButton(title: "Проверить", titleColor: .blue, backColor: .white)
        return button
    }()

    private lazy var leftButton: CustomButton = {
        let button = CustomButton(title: "Информация", titleColor: .black, backColor: .yellow)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()


    init(viewModel: FeedViewModel, coordinator: FeedFlowCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        taps()
        layout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    private func taps() {
        leftButton.tapAction = { [coordinator, navigationController] in
            coordinator.showInfo(nc: navigationController, coordinator: coordinator)
        }

        checkButton.tapAction = { [textField, passwordModel, textLabel] in
            guard let password = textField.text else { return }

            do {
                let _ = try passwordModel.check(password: password)
                textLabel.text = "Верно"
                textLabel.textColor = .systemGreen
            } catch {
                textLabel.text = "Неверно"
                textLabel.textColor = .systemRed

                let message: String
                switch error {
                case CheckError.emptyPassword:
                    message = "Пароль не введён"
                case CheckError.wrongPassword:
                    message = "Пароль неверный"
                default:
                    message = "Неизвестная ошибка"
                }

                let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
                let cancelAction = UIAlertAction(
                    title: "OK",
                    style: .cancel,
                    handler: nil)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    private func layout() {
        view.addSubview(textLabel)
        view.addSubview(textField)
        view.addSubview(checkButton)
        textLabel.snp.makeConstraints {
            $0.bottom.equalTo(textField.snp.top).offset(-16)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        textField.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(32)

        }
        checkButton.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(40)
            $0.top.equalTo(textField.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }

        view.addSubview(stackView)
        stackView.addArrangedSubview(leftButton)
        stackView.snp.makeConstraints {
            $0.top.equalTo(checkButton.snp.bottom).offset(100)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
    }
}
