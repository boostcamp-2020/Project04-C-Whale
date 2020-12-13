//
//  SceneDelegate.swift
//  HalgoraeDO
//
//  Created by 이상윤 on 2020/11/18.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func sceneWillEnterForeground(_ scene: UIScene) {
        NetworkMonitor.shared.startMonitoring()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        NetworkMonitor.shared.stopMonitoring()
    }
}

