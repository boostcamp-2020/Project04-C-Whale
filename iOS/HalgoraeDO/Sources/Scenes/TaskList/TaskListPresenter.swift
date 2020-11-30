//
//  TaskListPresenter.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import Foundation

protocol TaskListPresentLogic {
    func present(tasks: [Task])
    func set(editingMode: Bool)
    func presentDetail(of task: Task)
    func present(numberOfSelectedTasks count: Int)
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
    
    func set(editingMode: Bool) {
        viewController.set(editingMode: editingMode)
    }
    
    func presentDetail(of task: Task) {
        viewController.displayDetail(of: task)
    }
    
    func present(numberOfSelectedTasks count: Int) {
        viewController.display(numberOfSelectedTasks: count)
    }
}
