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
        btn.tag = 3
        return btn
    }()
    private lazy var settingsLbl: UILabel = {
        let lbl = UILabel()
        lbl.turnToStateLabel(Content.settingsTitle, font: view.frame.height * 0.07)
        lbl.tag = 4
        return lbl
    }()
    private lazy var chooseLanguageLbl: UILabel = {
        let lbl = UILabel()
        lbl.turnToStateLabel(Content.languageInstruction, font: view.frame.width * 0.022)
        return lbl
    }()
    private lazy var languagesCV: UICollectionView = {
        return turnToKeyCV(vc: self, tag: 1, CellClass: ImageCollectionViewCell.self, direction: .vertical, spacing: 10)
    }()
    private lazy var contactDevLbl: UILabel = {
        let lbl = UILabel()
        lbl.turnToStateLabel(Content.contactDevTitles[.Russian]!, font: view.frame.width * 0.022)
        return lbl
    }()
    private lazy var devLinksCV: UICollectionView = {
        return turnToKeyCV(vc: self, tag: 2, CellClass: ImageCollectionViewCell.self, direction: .vertical, spacing: 10)
    }()
    private lazy var creditsBtn: UIButton = {
        let btn = UIButton()
        btn.configureButton(with: nil, target: self, and: #selector(toggleCredits))
        btn.setupSettingsAppearence()
        btn.setTitle(Content.creditsTitle, for: .normal)
        btn.titleLabel!.font = UIFont(name: "Avenir-Heavy", size: view.frame.height * 0.045)
        return btn
    }()
    private lazy var versionLbl: UILabel = {
        let lbl = UILabel()
        lbl.turnToStateLabel(Content.version, font: view.frame.height * 0.03)
        return lbl
    }()
    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.alpha = 0
        tv.tag = 5
        tv.isScrollEnabled = true
        tv.isEditable = false
        tv.backgroundColor = .clear
        tv.text = Content.credits
        tv.font = UIFont(name: "Avenir-Roman", size: view.frame.height * 0.04)
        tv.textColor = .white
        return tv
    }()
    private var inCredits = false
    private var selectedLangIndex = 0
    
    
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
        view.addSubview(creditsBtn)
        view.addSubview(versionLbl)
        view.addSubview(textView)
        
        setSubviewsAutoresizingFalse()
        closeBtn.activateCloseBtnConstraints(view: self.view)
        activateConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        visualizeSelectedLang(true)
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
            
            languagesCV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            languagesCV.topAnchor.constraint(equalTo: settingsLbl.bottomAnchor, constant: 16),
            languagesCV.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            
            chooseLanguageLbl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            chooseLanguageLbl.trailingAnchor.constraint(lessThanOrEqualTo: languagesCV.trailingAnchor, constant: -12),
            chooseLanguageLbl.centerYAnchor.constraint(equalTo: languagesCV.centerYAnchor),
                        
            contactDevLbl.leadingAnchor.constraint(equalTo: chooseLanguageLbl.leadingAnchor),
            
            devLinksCV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: contactDevLbl.intrinsicContentSize.width + 32),
            devLinksCV.trailingAnchor.constraint(equalTo: languagesCV.trailingAnchor),
            devLinksCV.heightAnchor.constraint(equalTo: languagesCV.heightAnchor, multiplier: 0.8),
            devLinksCV.topAnchor.constraint(equalTo: languagesCV.bottomAnchor, constant: 16),
            
            languagesCV.leadingAnchor.constraint(equalTo: devLinksCV.leadingAnchor),
            
            contactDevLbl.centerYAnchor.constraint(equalTo: devLinksCV.centerYAnchor),
            
            creditsBtn.leadingAnchor.constraint(equalTo: contactDevLbl.leadingAnchor),
            creditsBtn.trailingAnchor.constraint(equalTo: languagesCV.trailingAnchor, constant: -8),
            creditsBtn.topAnchor.constraint(equalTo: devLinksCV.bottomAnchor, constant: 16),
            creditsBtn.heightAnchor.constraint(equalTo: languagesCV.heightAnchor, multiplier: 0.6),
            
            versionLbl.leadingAnchor.constraint(equalTo: closeBtn.leadingAnchor),
            versionLbl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            textView.leadingAnchor.constraint(equalTo: closeBtn.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: devLinksCV.trailingAnchor),
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
    private func toggleCredits() {
        inCredits = !inCredits
        
        self.settingsLbl.text = self.inCredits ?  Content.creditsTitle : Content.settingsTitle
        UIView.animate(withDuration: Content.animDuration, animations: {
            self.changeViewAlpha()
        })
    }
    
    private func changeViewAlpha() {
        for subview in view.subviews {
            checkSubviewTag(subview)
        }
    }
    
    private func checkSubviewTag(_ subview: UIView) {
        guard subview.tag != 3 && subview.tag != 4 else {
            return
        }
        if subview.tag == 5 {
            subview.alpha = inCredits ? 1 : 0
        } else {
            subview.alpha = inCredits ? 0 : 1
        }
    }
}


extension SettingsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return Content.languages.count
        } else {
            return Content.contacts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseID", for: indexPath) as! ImageCollectionViewCell
        
        guard collectionView.tag == 1 else {
            cell.imageName = Content.contacts[indexPath.row].name
            return cell
        }
        
        cell.imageName = Content.languages[indexPath.row]
        if Content.language.rawValue == Content.languages[indexPath.row] {
            selectedLangIndex = indexPath.row
        }
        return cell
    }
    
    private func visualizeSelectedLang(_ visualize: Bool) {
        let cell = languagesCV.cellForItem(at: IndexPath(row: selectedLangIndex, section: 0))
        cell!.layer.borderColor = visualize ? UIColor.white.cgColor : UIColor.clear.cgColor
        cell!.layer.borderWidth = visualize ? 2 : 0
        cell!.layer.cornerRadius = visualize ? cell!.frame.height / 2 : 0
    }
}

extension SettingsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            guard selectedLangIndex != indexPath.row else {
                return
            }
            visualizeSelectedLang(false)
            
            selectedLangIndex = indexPath.row
            
            visualizeSelectedLang(true)
            changeLanguage()
        } else {
            guard let url = URL(string: Content.contacts[indexPath.row].link) else { return }
            UIApplication.shared.open(url)
        }
    }
    
    private func changeLanguage() {
        Content.language = Language(rawValue: Content.languages[selectedLangIndex])!
        UserDefaults.standard.set(Content.language.rawValue, forKey: "chosenLanguage")
        
        LoadingOverlay.shared.showOverlay(vc: self, message: Content.waitingMessage)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.updateData()
            LoadingOverlay.shared.hideOverlayView()
        })
    }
    
    private func updateData() {
        settingsLbl.text = Content.settingsTitle
        chooseLanguageLbl.text = Content.languageInstruction
        contactDevLbl.text = Content.contactDev
        creditsBtn.setTitle(Content.creditsTitle, for: .normal)
        textView.text = Content.credits
    }
}

extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let constant = collectionView.frame.height
        return CGSize(width: constant, height: constant)
    }
}
