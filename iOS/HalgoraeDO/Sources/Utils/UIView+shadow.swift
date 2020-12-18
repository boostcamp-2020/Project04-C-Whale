//
//  UIView+shadow.swift
//  HalgoraeDO
//
//  Created by 이상윤 on 2020/12/17.
//

import UIKit

extension UIView {
    func shadow(radius: CGFloat = 5.0, color: UIColor = .black, offset: CGSize = .zero, opacity: Float = 0.2) {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = radius
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
    }
}
