//
//  TaskListPresenter.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import Foundation

protocol TaskListPresentLogic {
    func presentFetchTasks(response: TaskListModels.FetchTasks.Response)
    func presentDetail(of task: Task)
}

class TaskListPresenter {
    var viewController: TaskListDisplayLogic
    
    init(viewController: TaskListDisplayLogic) {
        self.viewController = viewController
    }
}

extension TaskListPresenter: TaskListPresentLogic {
    func presentFetchTasks(response: TaskListModels.FetchTasks.Response) {
        let taskViewModels = response.tasks.enumerated().map { (idx, task) in
            TaskListModels.DisplayedTask(task: task, position: idx, parentPosition: nil)
        }
        viewController.displayFetchTasks(viewModel: TaskListModels.FetchTasks.ViewModel(displayedTasks: taskViewModels))
    }
    
    func presentDetail(of task: Task) {
        
    }
}
