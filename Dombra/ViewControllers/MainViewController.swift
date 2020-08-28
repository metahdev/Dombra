//
//  MainViewController.swift
//  Dombra
//
//  Created by Metah on 3/1/20.
//  Copyright © 2020 devMetah. All rights reserved.
//

import UIKit
import GoogleMobileAds


// ca-app-pub-3940256099942544/2934735716 - test banner id

#warning("TODO")
/*
 1. YouTube video and Content
 2. Google Ads
 3. Refactoring(sound reusing, less CVs, icons resolutions)
 4. Write down future updates' plans
 */

protocol MainVCProtocol: class {
    func showVideoVC()
    func showSettingsVC()
    func closeChildView()
}

class MainViewController: UIViewController, MainVCProtocol {
    // MARK:- Properties
    private lazy var backgroundImageView = UIImageView()
    private lazy var bannerView: GADBannerView = {
        let v = GADBannerView()
        v.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        v.delegate = self
        v.rootViewController = self
        v.backgroundColor = .clear
        v.layer.zPosition = 4
        return v
    }()
    private lazy var dombraVC: DombraViewController = {
        let vc = DombraViewController()
        vc.main = self 
        return vc
    }()
    
    private var tempConstraints = [NSLayoutConstraint]()
    private var visualEffectView: UIVisualEffectView!
    private var currentVC: UIViewController! {
        didSet {
            showSelectedVC()
        }
    }
    

    // MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImageView.turnToBackground(view, image: "wood")
        
        addSubviews()
        addDombraVC()
        setAutoresizingToFalse()
        activateConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AudioPlayer.backgroundAudioPlayer.stop()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.bannerView.load(GADRequest())
        }
    }
    
    private func addDombraVC() {
        self.view.addSubview(dombraVC.view)
        self.addChild(dombraVC)
        dombraVC.didMove(toParent: parent)
    }
    
    private func addSubviews() {
        view.addSubview(bannerView)
    }
    
    private func setAutoresizingToFalse() {
        for subview in view.subviews {
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            dombraVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            dombraVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
            dombraVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dombraVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bannerView.topAnchor.constraint(equalTo: dombraVC.view.bottomAnchor),
            bannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}


// MARK:- BannerAd Delegate
extension MainViewController: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("ad recieved")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
    }
}


// MARK:- MainVCProtocol Methods
extension MainViewController {
    func showVideoVC() {
        currentVC = VideoViewController()
    }
    
    func showSettingsVC() {
        currentVC = SettingsViewController()
    }
    
    private func showSelectedVC() {
        addBlur()
        setProperties()
        NSLayoutConstraint.activate(tempConstraints)
        animWithValue(1.0, completion: {})
    }
    
    private func addBlur() {
        visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        
        visualEffectView.frame = view.frame
        visualEffectView.layer.zPosition = 2
        visualEffectView.isUserInteractionEnabled = false

        view.addSubview(visualEffectView)
    }
    
    private func setProperties() {
        (currentVC as! ChildVC).main = self
        currentVC.view.translatesAutoresizingMaskIntoConstraints = false
        currentVC.view.layer.zPosition = 3
        
        self.view.addSubview(currentVC.view)
        self.addChild(currentVC)
        currentVC.didMove(toParent: parent)
        initChildVCConstraints()
        setupAlphaValues(0)
    }
    
    private func initChildVCConstraints() {
        tempConstraints = [
            currentVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            currentVC.view.bottomAnchor.constraint(equalTo: bannerView.topAnchor),
            currentVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currentVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
    }
    
    private func setupAlphaValues(_ value: CGFloat) {
        self.currentVC.view.alpha = value
        self.visualEffectView.alpha = value
    }
    
    private func animWithValue(_ value: CGFloat, completion: @escaping () -> Void) {
        UIView.animate(withDuration: Content.animDuration, animations: {
            self.setupAlphaValues(value)
        }, completion: {(_) in
            completion()
        })
    }
}

extension MainViewController {
    func closeChildView() {
        dombraVC.updateData() 
        animWithValue(0, completion: {
            NSLayoutConstraint.deactivate(self.tempConstraints)
            self.removeBlur()
            self.currentVC.remove()
        })
    }
    
    private func removeBlur() {
        visualEffectView.removeFromSuperview()
    }
}
