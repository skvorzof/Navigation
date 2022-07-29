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

    private let cell: UITableViewCell = {
        let cell = UITableViewCell()
        return cell
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

        cell.imageView?.image = UIImage(named: url)
        setupUI()
    }

    private func setupUI() {
        view.addSubview(cell)
        cell.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }

    }

}
