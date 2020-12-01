//
//  UIViewController+segueIdentifier.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/01.
//

import UIKit

extension UIViewController {
    func segueIdentifier(to destination: UIViewController.Type) -> String {
        return "\(Self.self)To\(destination.self)"
    }
}
