//
//  MusicViewController.swift
//  Navigation
//
//  Created by mitr on 06.07.2022.
//

import AVFoundation
import UIKit

// MARK: - Constants
private struct Constants {
    static let playButtonName = "play.fill"
    static let stopButtonName = "stop.fill"
    static let pauseButtonName = "pause.fill"
    static let backwardButtonName = "backward.fill"
    static let forwardButtonName = "forward.fill"

    static let stackViewSpaccing: CGFloat = 32
    static let offset: CGFloat = 16
}

// MARK: - MusicViewController
class MusicViewController: UIViewController {

    private let viewModel = MusicViewModel()
    private var player = AVAudioPlayer()
    private var currentTrack = 0

    private let wrapView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private let titleTrackLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0)
        return label
    }()

    private let stackView = UIStackView()
    private let playPauseButton = UIButton()
    private let stopButton = UIButton()
    private let backwardButton = UIButton()
    private let forwardButton = UIButton()

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPlayer()
        setupStackView()
        setupUI()
        backwardButton.isEnabled = false
    }

    // MARK: - setupPlayer
    private func setupPlayer(trackNumber: Int = 0) {

        currentTrack = trackNumber
        let track = viewModel.tracks[trackNumber].url
        guard let trackURL = Bundle.main.url(forResource: track, withExtension: "mp3") else { return }
        do {
            let playerItem = AVPlayerItem(url: trackURL)
            let metadataList = playerItem.asset.metadata
            for item in metadataList {
                guard let key = item.commonKey?.rawValue, let value = item.value else { continue }

                switch key {
                case "title": titleTrackLabel.text = value as? String
                default:
                    continue
                }
            }

            player = try AVAudioPlayer(contentsOf: trackURL)
            player.prepareToPlay()
        } catch {
            print(error)
        }
    }

    // MARK: - setupStackView
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.spacing = Constants.stackViewSpaccing
    }

    // MARK: - createButtons
    private func createButton(_ button: UIButton, image: String, action: Selector) {
        button.tintColor = .black
        button.setImage(UIImage(systemName: image), for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        stackView.addArrangedSubview(button)
    }

    // MARK: - createUI
    private func setupUI() {
        createButton(backwardButton, image: Constants.backwardButtonName, action: #selector(backwardTrack))
        createButton(playPauseButton, image: Constants.playButtonName, action: #selector(tapPlayPauseButton))
        createButton(stopButton, image: Constants.stopButtonName, action: #selector(tapStopButton))
        createButton(forwardButton, image: Constants.forwardButtonName, action: #selector(forwardTrack))

        view.addSubview(wrapView)
        wrapView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(-200)
        }

        wrapView.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(wrapView)
        }

        view.addSubview(titleTrackLabel)
        titleTrackLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(wrapView.snp.bottom).offset(Constants.offset)
        }

        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleTrackLabel.snp.bottom).offset(Constants.offset * 2)
        }
    }

    // MARK: - Actions
    @objc
    private func tapPlayPauseButton() {
        switch currentTrack {
        case 0:
            backwardButton.isEnabled = false
        case viewModel.tracks.count - 1:
            forwardButton.isEnabled = false
        default:
            backwardButton.isEnabled = true
            forwardButton.isEnabled = true
        }

        if player.isPlaying {
            player.pause()
            playPauseButton.setImage(UIImage(systemName: Constants.playButtonName), for: .normal)
        } else {
            player.play()
            playPauseButton.setImage(UIImage(systemName: Constants.pauseButtonName), for: .normal)
        }

    }

    @objc
    private func tapStopButton() {
        player.stop()
        player.currentTime = 0
        playPauseButton.setImage(UIImage(systemName: Constants.playButtonName), for: .normal)
    }

    @objc
    private func backwardTrack() {
        if currentTrack > 0 {
            setupPlayer(trackNumber: currentTrack - 1)
            tapPlayPauseButton()
        }
    }

    @objc
    private func forwardTrack() {
        if currentTrack < viewModel.tracks.count - 1 {
            setupPlayer(trackNumber: currentTrack + 1)
            tapPlayPauseButton()
        }
    }

}

// MARK: - MusicViewController: UITableViewDataSource
extension MusicViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tracks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        var content: UIListContentConfiguration = cell.defaultContentConfiguration()
        content.text = viewModel.tracks[indexPath.row].title
        content.secondaryText = viewModel.tracks[indexPath.row].artist
        cell.contentConfiguration = content
        return cell
    }
}

// MARK: - MusicViewController: UITableViewDelegate
extension MusicViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        setupPlayer(trackNumber: indexPath.row)
        tapPlayPauseButton()
    }
}
