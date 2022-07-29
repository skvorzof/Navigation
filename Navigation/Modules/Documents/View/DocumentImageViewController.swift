//
//  DocumentImageViewController.swift
//  Navigation
//
//  Created by mitr on 28.07.2022.
//

import SnapKit
import UIKit

class DocumentImageViewController: UIViewController {
    private let url: String

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        imageView.image = UIImage(named: url)
        view.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

    }

}
