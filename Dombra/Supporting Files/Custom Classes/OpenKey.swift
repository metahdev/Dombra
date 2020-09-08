//
//  OpenKey.swift
//  Dombra
//
//  Created by Metah on 9/8/20.
//  Copyright © 2020 devMetah. All rights reserved.
//

import UIKit

protocol OpenKeyDelegate: class {
    var firstStringVector: [CGFloat] { get }
    var secondStringVector: [CGFloat] { get }
    
    func handleFirstStringSwipe()
    func handleSecondStringSwipe()
}

class OpenKey: UIView {
    // MARK:- Delegate
    var delegate: OpenKeyDelegate!
    private var start: CGFloat?
    private var finalY: CGFloat?
    private let minDistance: CGFloat = 15.0
    
    
    // MARK:- Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {
            return
        }
        start = point.y
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let start = self.start else {
            self.start = nil
            return
        }
        finalY = touch.location(in: self).y
        let dy = abs(finalY! - start)
        
        if dy > minDistance {
            checkForDownSwipe(ofFirstString: true)
            checkForDownSwipe(ofFirstString: false)
            checkForUpperSwipe(ofFirstString: true)
            checkForUpperSwipe(ofFirstString: false)
        }
        super.touchesEnded(touches, with: event)
    }
    
    private func checkForDownSwipe(ofFirstString: Bool) {
        let vector = ofFirstString ? delegate.firstStringVector : delegate.secondStringVector
        if start! <= vector[0] && finalY! >= vector[1] {
            ofFirstString ? delegate.handleFirstStringSwipe() : delegate.handleSecondStringSwipe()
        }
    }
    
    private func checkForUpperSwipe(ofFirstString: Bool) {
        let vector = ofFirstString ? delegate.firstStringVector : delegate.secondStringVector
        if start! >= vector[1] && finalY! <= vector[0] {
            ofFirstString ? delegate.handleFirstStringSwipe() : delegate.handleSecondStringSwipe()
        }
    }
}
