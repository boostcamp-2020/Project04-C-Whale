//
//  SceneDelegate.swift
//  HalgoraeDO
//
//  Created by 이상윤 on 2020/11/18.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var storage: Storage {
        return Storage()
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        NetworkMonitor.shared.startMonitoring()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        NetworkMonitor.shared.stopMonitoring()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
        storage.saveContext(context: storage.mainContext)
    }
}

