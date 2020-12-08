//
//  MenuRouter.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/08.
//

import Foundation

protocol MenuRoutingLogic {
    
}

protocol MenuDataPassing {
    var dataStore: MenuDataStore { get }
}

class MenuRouter: MenuDataPassing {
    
    let dataStore: MenuDataStore
    weak var viewController: MenuViewController?
    
    init(dataStore: MenuDataStore, viewController: MenuViewController) {
        self.dataStore = dataStore
        self.viewController = viewController
    }
}

extension MenuRouter: MenuRoutingLogic {
    
}
