//
//  SimpleAlertController.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/19.
//

import UIKit

class SimpleAlertController: UIAlertController {
    
    func configureActions(_ actions: [UIAlertAction]) {
        actions.forEach { addAction($0) }
    }
}
