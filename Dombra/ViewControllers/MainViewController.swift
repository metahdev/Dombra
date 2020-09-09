//
//  MainViewController.swift
//  Dombra
//
//  Created by Metah on 3/1/20.
//  Copyright © 2020 devMetah. All rights reserved.
//

import UIKit

protocol MainVCProtocol: class {
    func showVideoVC()
    func showSettingsVC()
    func closeChildView()
}

class MainViewController: UIViewController, MainVCProtocol {
    // MARK:- Properties
    private lazy var backgroundImageView = UIImageView()
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
        
        addDombraVC()
        setAutoresizingToFalse()
        activateConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AudioPlayer.backgroundAudioPlayer.stop()
    }
    
    private func addDombraVC() {
        self.view.addSubview(dombraVC.view)
        self.addChild(dombraVC)
        dombraVC.didMove(toParent: parent)
    }
    
    private func setAutoresizingToFalse() {
        for subview in view.subviews {
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            dombraVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            dombraVC.view.heightAnchor.constraint(equalTo: view.heightAnchor),
            dombraVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dombraVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}


// MARK:- System Gestures
extension MainViewController {
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return UIRectEdge.all
    }
}


// MARK:- MainVCProtocol methods
extension MainViewController {
    func showVideoVC() {
        currentVC = VideoViewController()
    }
    
    func showSettingsVC() {
        currentVC = SettingsViewController()
    }
    
    private func showSelectedVC() {
        initBlur()
        view.addSubview(visualEffectView)
        
        setupChild()
        initChildVCConstraints()
        setupAlphaValues(0)
        NSLayoutConstraint.activate(tempConstraints)
        animWithValue(1.0, completion: {})
    }
    
    private func initBlur() {
        visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        
        visualEffectView.frame = view.frame
        visualEffectView.isUserInteractionEnabled = false
    }
    
    private func setupChild() {
        (currentVC as! ChildVC).main = self
        currentVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(currentVC.view)
        self.addChild(currentVC)
        currentVC.didMove(toParent: parent)
    }
    
    private func initChildVCConstraints() {
        tempConstraints = [
            currentVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            currentVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
    // MARK:- MainVCProtocol navigation
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
