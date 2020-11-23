//
//  TaskListRouter.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import Foundation

protocol TaskListRoutingLogic {
    
}

protocol TaskListDataPassing {
    var dataStore: TaskListDataStore { get set }
}

class TaskListRouter: TaskListDataPassing {
    weak var viewController: TaskListViewController?
    var dataStore: TaskListDataStore
    
    init(viewController: TaskListViewController, dataStore: TaskListDataStore) {
        self.viewController = viewController
        self.dataStore = dataStore
    }
}

extension TaskListRouter: TaskListRoutingLogic {
    
    
}
