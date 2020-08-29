//
//  CollectionViewCells.swift
//  Dombra
//
//  Created by Metah on 5/10/20.
//  Copyright © 2020 devMetah. All rights reserved.
//

import UIKit

class KeyCollectionViewCell: UICollectionViewCell {
    // MARK:- Properties
    var clearBlurEffectView: UIVisualEffectView?
    var greenBlurEffectView: UIVisualEffectView?
    
    
    //MARK:- Cell separation
    override func draw(_ rect: CGRect) {
        let cgContext = UIGraphicsGetCurrentContext()
        cgContext?.move(to: CGPoint(x: rect.minX, y: rect.minY))
        cgContext?.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        cgContext?.setStrokeColor(Content.silverColor.cgColor)
        cgContext?.setLineWidth(4.0)
        cgContext?.strokePath()
    }
    
    
    // MARK:- Highlighting
    func addBlurEffectViews() {
        clearBlurEffectView = addBlurEffectView(.clear, alpha: 1.0)
        greenBlurEffectView = addBlurEffectView(Content.highlightColor, alpha: 0.0)
    }
    
    private func addBlurEffectView(_ color: UIColor?, alpha: CGFloat) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.backgroundColor = Content.highlightColor
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        blurEffectView.backgroundColor = color
        blurEffectView.alpha = alpha
        
        self.addSubview(blurEffectView)
        return blurEffectView
    }
    
    func removeBlurs() {
        clearBlurEffectView?.removeFromSuperview()
        greenBlurEffectView?.removeFromSuperview()
    }
}

class DotCollectionViewCell: UICollectionViewCell {
    func createDot() {
        let circle = UIView()
        circle.backgroundColor = .white
        circle.translatesAutoresizingMaskIntoConstraints = false
            
        self.addSubview(circle)
        let constant = self.frame.height * 0.2
        NSLayoutConstraint.activate([
            circle.heightAnchor.constraint(equalToConstant: constant),
            circle.widthAnchor.constraint(equalToConstant: constant),
            circle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            circle.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        circle.layer.cornerRadius = constant * 0.5
    }
}


class ImageCollectionViewCell: UICollectionViewCell {
    // MARK:- Properties
    var imageName = "" {
        didSet {
            imageView.image = UIImage(named: imageName)
        }
    }
    private var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    
    // MARK:- Initialization
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        activateConstraints()
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
