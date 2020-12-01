//
//  TaskListRouter.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import UIKit

protocol TaskListRoutingLogic {
    func routeToTaskDetail(for taskVM: TaskListModels.DisplayedTask)
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
    
    func routeToTaskDetail(for taskVM: TaskListModels.DisplayedTask) {
        guard let sourceVC = viewController,
            let task = dataStore.taskList.task(identifier: taskVM.id, postion: taskVM.position, parentPosition: taskVM.parentPosition),
            let destinationVC = viewController?.storyboard?.instantiateViewController(identifier: "\(TaskDetailViewController.self)",
                                                                                creator: { (coder) -> TaskDetailViewController? in
                return TaskDetailViewController(coder: coder, task: task)
            })
        else {
            return
        }
        
        navigateToTaskDetail(source: sourceVC, destination: destinationVC)
    }
    
    
    func routeToTaskDetail(segue: UIStoryboardSegue?) {
        guard let sourceVC = viewController,
            let destinationVC = segue?.destination as? TaskDetailViewController
        else {
            return
        }
        navigateToTaskDetail(source: sourceVC, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    func navigateToTaskDetail(source: TaskListViewController, destination: TaskDetailViewController) {
        source.present(destination, animated: true, completion: nil)
    }
}
