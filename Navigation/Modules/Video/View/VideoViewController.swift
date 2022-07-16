//
//  VideoViewController.swift
//  Navigation
//
//  Created by mitr on 06.07.2022.
//

import UIKit

// MARK: - VideoViewController
class VideoViewController: UIViewController {

    private let viewModel = VideoViewModel()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func playVideo(urlVideo: String) {
        let vc = VideoPlayerViewController(url: urlVideo)
        present(vc, animated: true)
    }

    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.trailing.bottom.leading.equalToSuperview()
        }

    }
}

// MARK: - VideoViewController: UITableViewDataSource
extension VideoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        var content: UIListContentConfiguration = cell.defaultContentConfiguration()
        content.text = viewModel.urls[indexPath.row].title
        cell.contentConfiguration = content
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.urls.count
    }
}

// MARK: - VideoViewController: UITableViewDelegate
extension VideoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playVideo(urlVideo: viewModel.urls[indexPath.row].url)
    }
}
