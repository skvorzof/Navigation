//
//  FeedViewController.swift
//  Navigation
//
//  Created by mitr on 03.03.2022.
//

import UIKit

class FeedViewController: UIViewController {

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
    
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var leftButton: CustomButton = {
        let button = CustomButton(title: "Первая", titleColor: .black, backColor: .yellow)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()
    
    private lazy var rightButton: CustomButton = {
        let button = CustomButton(title: "Вторая", titleColor: .white, backColor: .brown)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()
    
    
    
    private func taps() {
        leftButton.tapAction = { [weak self] in
            let infoVC = InfoViewController()
            self?.navigationController?.pushViewController(infoVC, animated: true)
        }
        
        rightButton.tapAction = { [weak self] in
            let infoVC = InfoViewController()
            self?.navigationController?.pushViewController(infoVC, animated: true)
        }
    }
    
    
    private func layout() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(leftButton)
        stackView.addArrangedSubview(rightButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
}
