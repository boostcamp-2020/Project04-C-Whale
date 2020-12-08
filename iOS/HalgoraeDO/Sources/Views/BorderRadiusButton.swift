//
//  BorderButton.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/02.
//

import UIKit

class BorderRadiusButton: UIButton {
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable
    var radius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    func configure(borderWidth: CGFloat, borderColor: UIColor, radius: CGFloat) {
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.radius = radius
    }
}
