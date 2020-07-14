//
//  VideoViewController.swift
//  Dombra
//
//  Created by Metah on 7/6/20.
//  Copyright © 2020 devMetah. All rights reserved.
//

import UIKit
import youtube_ios_player_helper


class VideoViewController: UIViewController {
    // MARK:- Properties
    weak var main: MainViewControllerProtocol!
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.turnToStateLabel(Content.infoTitle, font: view.frame.height * 0.05)
        return lbl
    }()
    private lazy var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.turnToStateLabel(Content.infoDescription, font: view.frame.height * 0.04)
        return lbl
    }()
    private lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "close"), for: .normal)
        btn.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        return btn
    }()
    private lazy var videoView: YTPlayerView = {
        let view = YTPlayerView()
        view.delegate = self
        view.clipsToBounds = false
        return view
    }()
    private let videoID = "s1A6arvZQHI"
    private let playVarsDic = ["controls": 1, "playsinline": 1, "showinfo": 1, "autoplay": 0, "rel": 0]
        
    
    // MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(closeBtn)
        view.addSubview(videoView)
        
        setSubviewsAutoresizingFalse()
        activateConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoView.load(withVideoId: videoID, playerVars: playVarsDic)
    }

    private func setSubviewsAutoresizingFalse() {
        for subview in view.subviews {
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            videoView.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1.4),
            videoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            videoView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            videoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            closeBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            closeBtn.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            closeBtn.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            closeBtn.widthAnchor.constraint(equalTo: closeBtn.heightAnchor),
            
            descriptionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    // MARK:- Actions
    @objc
    private func closeView() {
        videoView.stopVideo()
        main.closeChildView()
    }
}

extension VideoViewController: YTPlayerViewDelegate {
    func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor {
        return .clear
    }
}
