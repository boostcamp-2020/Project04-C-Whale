//
//  MenuRouter.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/08.
//

import Foundation

protocol MenuRoutingLogic {
    func routeToTaskList(for project: MenuModels.ProjectVM)
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
    
    func routeToTaskList(for project: MenuModels.ProjectVM) {
        let projectId = project.id.replacingOccurrences(of: "+", with: "")
        
        let storyboard = viewController?.storyboard
        guard let projectIndex = dataStore.projects.firstIndex(where: { $0.id == projectId }),
            let vc = storyboard?.instantiateViewController(identifier: "\(TaskListViewController.self)",
                                                        creator: { [unowned self] (coder) -> TaskListViewController? in
            return TaskListViewController(coder: coder, project: self.dataStore.projects[projectIndex])
        })
        else {
            return
        }
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
