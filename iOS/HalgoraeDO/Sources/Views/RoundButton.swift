//
//  RoundButton.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/24.
//

import UIKit

class RoundButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height/2
    }
}
