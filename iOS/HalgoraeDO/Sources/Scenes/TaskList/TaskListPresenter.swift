//
//  TaskListPresenter.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import Foundation

protocol TaskListPresentLogic {
    func present(tasks: [Task])
    func presentDetail(of task: Task)
}

class TaskListPresenter {
    var viewController: TaskListDisplayLogic
    
    init(viewController: TaskListDisplayLogic) {
        self.viewController = viewController
    }
}

extension TaskListPresenter: TaskListPresentLogic {
    func present(tasks: [Task]) {
        viewController.display(tasks: tasks)
    }
    
    func presentDetail(of task: Task) {
        viewController.displayDetail(of: task)
    }
}
