//
//  VideoPlayerViewController.swift
//  Navigation
//
//  Created by mitr on 11.07.2022.
//

import UIKit
import YouTubeiOSPlayerHelper

// MARK: - VideoPlayerViewController
class VideoPlayerViewController: UIViewController {

    let url: String

    private lazy var player: YTPlayerView = {
        let player = YTPlayerView()
        player.delegate = self
        return player
    }()

    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        player.load(withVideoId: url)
        setupUI()
    }

    // MARK: - setupUI
    private func setupUI() {
        view.addSubview(player)

        player.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(view.frame.size.width / 1.78)
            $0.center.equalToSuperview()
        }
    }

}

// MARK: - VideoPlayerViewController: YTPlayerViewDelegate
extension VideoPlayerViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        player.playVideo()
    }
}
