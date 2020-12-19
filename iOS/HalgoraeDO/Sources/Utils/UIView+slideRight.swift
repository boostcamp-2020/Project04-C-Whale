//
//  UIView+SlideRight.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/19.
//

import UIKit

extension UIView {
    
    func slideRight(withDuration duration: TimeInterval = 0.5,
                    delay: TimeInterval = 0,
                    usingSpringWithDamping dampingRatio: CGFloat = 0.7,
                    initialSpringVelocity velocity: CGFloat = 0.5,
                    options: UIView.AnimationOptions = [.curveEaseIn]) {
        self.transform = .init(translationX: -self.frame.maxX, y: 0)
        self.isHidden = false
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity, options: options) {
            self.transform = .identity
        }
    }
}
