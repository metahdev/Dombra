//
//  ContainerView.swift
//  Dombra
//
//  Created by Metah on 7/6/20.
//  Copyright © 2020 devMetah. All rights reserved.
//

import UIKit

class ContainerView: UIView {
    // MARK:- Properties
    private lazy var leftDot: UIView = {
        let view = UIView()
        setupDot(view)
        return view
    }()
    private lazy var rightDot: UIView = {
        let view = UIView()
        setupDot(view)
        return view
    }()
    private func setupDot(_ view: UIView) {
        view.backgroundColor = .gray
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 5
        
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
    }
    
    
    // MARK:- Constraints
    func setupLayout(_ playBtn: UIButton) {
        self.addSubview(leftDot)
        self.addSubview(rightDot)
        activateConstraints()
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            leftDot.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            leftDot.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            leftDot.topAnchor.constraint(equalTo: self.topAnchor),
            leftDot.heightAnchor.constraint(equalTo: self.widthAnchor),
            
            rightDot.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            rightDot.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            rightDot.heightAnchor.constraint(equalTo: self.widthAnchor),
            rightDot.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    
    // MARK:- Helpful methods
    func clearAllDots() {
        for subview in self.subviews {
            subview.backgroundColor = .gray
        }
    }
    
    func fillLeftDot() {
        leftDot.backgroundColor = .green
    }
    
    func fillRightDot() {
        rightDot.backgroundColor = .green
    }
}
