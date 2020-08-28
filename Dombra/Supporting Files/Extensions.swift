//
//  Extensions.swift
//  Dombra
//
//  Created by Metah on 3/1/20.
//  Copyright © 2020 devMetah. All rights reserved.
//

import UIKit

extension UIImageView {
    func turnToBackground(_ view: UIView, image name: String) {
        let image = UIImage(named: name)
        self.contentMode = .scaleAspectFill
        self.image = image
        self.layer.zPosition = -1
        
        view.addSubview(self)
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func turnToString() {
        self.image = UIImage(named: "string")
        self.layer.zPosition = 1
        self.isUserInteractionEnabled = false
    }
}

extension UILabel {
    func turnToContinueLabel(_ view: UIView) {
        self.text = Content.continueText
        self.font = UIFont(name: "Didot", size: view.frame.height * 0.05)
        self.textAlignment = .center
        self.textColor = .white
        
        view.addSubview(self)
        NSLayoutConstraint.activate([
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24)
        ])
    }
    
    func turnToStateLabel(_ text: String, font size: CGFloat) {
        self.textColor = .white
        self.font = UIFont(name: "Avenir-Light", size: size)
        self.textAlignment = .center
        self.text = text
        self.numberOfLines = 2
    }
}

extension UIButton {
    func configureButton(with image: String?, target: UIViewController, and action: Selector) {
        if let image = image {
            self.setBackgroundImage(UIImage(named: image), for: .normal)
        }
        self.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func turnToCloseBtn(target: UIViewController, action: Selector) {
        self.setImage(UIImage(named: "close"), for: .normal)
        self.addTarget(self, action: action, for: .touchUpInside)
    }
    
    func setupSettingsAppearence() {
        self.layer.cornerRadius = 15
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 3
    }
    
    func activateCloseBtnConstraints(view: UIView) {
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            self.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            self.widthAnchor.constraint(equalTo: self.heightAnchor),
        ])
    }
}

extension UIView {
    func makeItDisappear() {
        self.isUserInteractionEnabled = false
        self.alpha = 0
    }
}


extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

// MARK:- Global Functions
func turnToKeyCV(vc: UIViewController, tag: Int, CellClass: AnyClass, direction: UICollectionView.ScrollDirection, spacing: CGFloat) -> UICollectionView {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = direction
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.minimumLineSpacing = spacing
    
    let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    cv.register(CellClass, forCellWithReuseIdentifier: "reuseID")
    cv.isScrollEnabled = false
    
    cv.delegate = vc as? UICollectionViewDelegate
    cv.dataSource = vc as? UICollectionViewDataSource
    cv.tag = tag
    cv.isUserInteractionEnabled = true
    if tag > 1001 && tag != 1005 {
        cv.isUserInteractionEnabled = false
    }
    cv.backgroundColor = .clear
    return cv
}
