//
//  UIColor+.swift
//  HalgoraeDO
//
//  Created by 이상윤 on 2020/12/01.
//

import UIKit

extension UIColor {
    
    class var halgoraedoMint: UIColor {
        return UIColor(named: "halgoraedoMint")!
    }
    
    class var halgoraedoDarkBlue: UIColor {
        return UIColor(named: "halgoraedoDarkBlue")!
    }
}

extension UIColor {
    
    convenience init(hexFromString: String, alpha: CGFloat = 1.0) {
        var cString:String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue: UInt64 = 10066329 //color #999999 if string has wrong format

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt64(&rgbValue)
        }

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

