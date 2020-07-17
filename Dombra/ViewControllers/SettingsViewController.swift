//
//  SettingsViewController.swift
//  Dombra
//
//  Created by Metah on 7/6/20.
//  Copyright © 2020 devMetah. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, ChildVC {
    // MARK:- Properties
    weak var main: MainVCProtocol!
    private lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "close"), for: .normal)
        btn.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        return btn
    }()
    private lazy var languagesCV: UICollectionView = {
        return turnToKeyCV(vc: self, tag: 1005, CellClass: ImageCollectionViewCell.self, direction: .vertical, spacing: 10)
    }()
    private var languageImages = ["Kazakh", "English", "Russian"]
    
    // MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        view.addSubview(closeBtn)
        
        setSubviewsAutoresizingFalse()
        closeBtn.activateCloseBtnConstraints(view: self.view)
        activateConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func setSubviewsAutoresizingFalse() {
        for subview in view.subviews {
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            
        ])
    }
    
    
    // MARK:- Actions
    @objc
    private func closeView() {
        main.closeChildView()
    }
}


extension SettingsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseID", for: indexPath) as! ImageCollectionViewCell
        cell.imageName = languageImages[indexPath.row]
        return cell
    }
}

extension SettingsViewController: UICollectionViewDelegate {
    
}

extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let constant = collectionView.frame.height
        return CGSize(width: constant, height: constant)
    }
}
