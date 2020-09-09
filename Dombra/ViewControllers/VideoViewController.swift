//
//  VideoViewController.swift
//  Dombra
//
//  Created by Metah on 7/6/20.
//  Copyright © 2020 devMetah. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

protocol ChildVC: class {
    var main: MainVCProtocol! { get set }
}

class VideoViewController: UIViewController, ChildVC {
    // MARK:- Properties
    weak var main: MainVCProtocol!
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.turnToStateLabel(Content.infoTitle, font: view.frame.height * 0.07)
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
    private let videoID = "p8jnwChiea8"
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
        closeBtn.activateCloseBtnConstraints(view: self.view) 
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
            
            titleLabel.centerYAnchor.constraint(equalTo: closeBtn.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
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
