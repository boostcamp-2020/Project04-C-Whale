//
//  MenuViewController.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/27.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        performSegue(withIdentifier: "MenuViewControllerTo TaskListViewController", sender: nil)
    }
}
