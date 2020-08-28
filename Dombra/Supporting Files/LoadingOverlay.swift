//
//  LoadingOverlay.swift
//  Dombra
//
//  Created by Metah on 8/28/20.
//  Copyright © 2020 devMetah. All rights reserved.
//

import UIKit

struct LoadingOverlay {
    private static var alert: UIAlertController!
    private static var indicator: UIActivityIndicatorView!
    
    static func showOverlay(vc: UIViewController, message: String) {
        alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.startAnimating()

        indicator.translatesAutoresizingMaskIntoConstraints = false
        alert.view.addSubview(indicator)
        
        indicator.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor).isActive = true
        indicator.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -20).isActive = true
        alert.view.heightAnchor.constraint(equalToConstant: 95).isActive = true

        vc.present(alert, animated: true, completion: nil)
    }
    
    static func hideOverlayView() {
        indicator.stopAnimating()
        alert.dismiss(animated: true, completion: nil)
    }
}
