//
//  TaskListRouter.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import UIKit

protocol TaskListRoutingLogic {
    func routeToTaskDetail(for taskVM: TaskListModels.TaskVM, at indexPath: IndexPath)
    func routeToTaskDetailFromBoard(for taskVM: TaskListModels.TaskVM, at indexPath: IndexPath)
}

protocol TaskListDataPassing {
    var dataStore: TaskListDataStore { get set }
}

class TaskListRouter: TaskListDataPassing {
    weak var listViewController: TaskListViewController?
    weak var boardViewController: TaskBoardViewController?
    var dataStore: TaskListDataStore
    
    init(viewController: TaskListViewController?, boardViewController: TaskBoardViewController? = nil, dataStore: TaskListDataStore) {
        self.listViewController = viewController
        self.boardViewController = boardViewController
        self.dataStore = dataStore
    }
}

extension TaskListRouter: TaskListRoutingLogic {
    
    func routeToTaskDetailFromBoard(for taskVM: TaskListModels.TaskVM, at indexPath: IndexPath) {
        guard let sourceVC = boardViewController,
            let task = dataStore.taskList.task(taskVM: taskVM, indexPath: indexPath),
            let destinationVC = sourceVC.storyboard?.instantiateViewController(identifier: "\(TaskDetailViewController.self)",
                                                                                creator: { (coder) -> TaskDetailViewController? in
                return TaskDetailViewController(coder: coder, task: task)
            })
        else {
            return
        }
        
        navigateToTaskDetail(source: sourceVC, destination: destinationVC)
    }
 
    func routeToTaskDetail(for taskVM: TaskListModels.TaskVM, at indexPath: IndexPath) {
        guard let sourceVC = listViewController,
            let task = dataStore.taskList.task(taskVM: taskVM, indexPath: indexPath),
            let destinationVC = listViewController?.storyboard?.instantiateViewController(identifier: "\(TaskDetailViewController.self)",
                                                                                creator: { (coder) -> TaskDetailViewController? in
                return TaskDetailViewController(coder: coder, task: task)
            })
        else {
            return
        }
        
        navigateToTaskDetail(source: sourceVC, destination: destinationVC)
    }
    
    
    func routeToTaskDetail(segue: UIStoryboardSegue?) {
        guard let sourceVC = listViewController,
            let destinationVC = segue?.destination as? TaskDetailViewController
        else {
            return
        }
        
        navigateToTaskDetail(source: sourceVC, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    func navigateToTaskDetail(source: UIViewController, destination: TaskDetailViewController) {
        source.present(destination, animated: true, completion: nil)
    }
}
