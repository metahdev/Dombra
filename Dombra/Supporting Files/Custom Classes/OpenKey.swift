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
            checkCoordinates(ofFirstString: true, checkEnd: false)
            checkCoordinates(ofFirstString: true, checkEnd: true)
            checkCoordinates(ofFirstString: false, checkEnd: false)
            checkCoordinates(ofFirstString: false, checkEnd: true)
        }
        super.touchesEnded(touches, with: event)
    }
    
    private func checkCoordinates(ofFirstString: Bool, checkEnd: Bool) {
        let vector = ofFirstString ? delegate.firstStringVector : delegate.secondStringVector
        var begin = 0
        var end = 1
        if checkEnd {
            swap(&begin, &end)
        }
        if start! <= vector[begin] && finalY! >= vector[end] {
            ofFirstString ? delegate.handleFirstStringSwipe() : delegate.handleSecondStringSwipe()
        }
    }
}
