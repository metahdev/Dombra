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
        btn.tag = 1
        return btn
    }()
    private lazy var settingsLbl: UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    private lazy var chooseLanguageLbl: UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    private lazy var languagesCV: UICollectionView = {
        return turnToKeyCV(vc: self, tag: 1005, CellClass: ImageCollectionViewCell.self, direction: .vertical, spacing: 10)
    }()
    private lazy var contactDevLbl: UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    private lazy var devLinksCV: UICollectionView = {
        return turnToKeyCV(vc: self, tag: 1005, CellClass: ImageCollectionViewCell.self, direction: .vertical, spacing: 10)
    }()
    private lazy var rateAppStoreBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()
    private lazy var creditsBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()
    private lazy var versionLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = Content.version
        return lbl
    }()
    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.isHidden = true
        tv.tag = 2
        return tv
    }()
    private var inCredits = false
    
    
    // MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        view.addSubview(closeBtn)
        view.addSubview(settingsLbl)
        view.addSubview(chooseLanguageLbl)
        view.addSubview(languagesCV)
        view.addSubview(contactDevLbl)
        view.addSubview(devLinksCV)
        view.addSubview(rateAppStoreBtn)
        view.addSubview(creditsBtn)
        view.addSubview(versionLbl)
        view.addSubview(textView)
        
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
            settingsLbl.centerYAnchor.constraint(equalTo: closeBtn.centerYAnchor),
            settingsLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            contactDevLbl.leadingAnchor.constraint(equalTo: closeBtn.leadingAnchor),
            contactDevLbl.topAnchor.constraint(equalTo: settingsLbl.bottomAnchor, constant: 20),
            
            devLinksCV.leadingAnchor.constraint(equalTo: contactDevLbl.trailingAnchor),
            
            
            versionLbl.leadingAnchor.constraint(equalTo: closeBtn.leadingAnchor),
            versionLbl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            textView.leadingAnchor.constraint(equalTo: closeBtn.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.topAnchor.constraint(equalTo: settingsLbl.bottomAnchor, constant: 16),
            textView.bottomAnchor.constraint(equalTo: versionLbl.bottomAnchor),
        ])
    }
    
    
    // MARK:- Actions
    @objc
    private func closeView() {
        if inCredits {
            toggleCredits()
        } else {
            main.closeChildView()
        }
    }
    
    @objc
    private func showCredits() {
        toggleCredits()
    }
    
    private func toggleCredits() {
        inCredits = !inCredits
        
        UIView.animate(withDuration: Content.animDuration, animations: {
            self.changeViewAlpha()
        }, completion: { _ in
            self.settingsLbl.text = self.inCredits ? Content.settingsTitle : Content.creditsTitle
        })
    }
    
    private func changeViewAlpha() {
        #warning("test if it runs")
        for subview in view.subviews {
            guard subview.tag != 1 else {
                return
            }
            checkSubviewTag(subview)
        }
    }
    
    private func checkSubviewTag(_ subview: UIView) {
        if subview.tag == 2 {
            subview.isHidden = !inCredits
        } else {
            subview.alpha = inCredits ? 0 : 1
        }
    }
}


extension SettingsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 3 {
            return Content.languages.count
        } else {
            return Content.devLinks.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        #warning("test if it runs x2")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseID", for: indexPath) as! ImageCollectionViewCell
        if collectionView.tag == 3 {
            cell.imageName = Content.languages[indexPath.row]
        } else {
            cell.imageName = Content.devLinks[indexPath.row]
        }
        return cell
    }
}

extension SettingsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let constant = collectionView.frame.height
        return CGSize(width: constant, height: constant)
    }
}
