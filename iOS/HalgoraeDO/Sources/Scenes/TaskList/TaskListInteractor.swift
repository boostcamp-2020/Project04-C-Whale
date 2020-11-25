//
//  TaskListInteractor.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import Foundation

protocol TaskListBusinessLogic {
    func fetchTasks()
    func change(editingMode: Bool, animated: Bool)
    func select(task: Task)
}

protocol TaskListDataStore {
    
}

class TaskListInteractor: TaskListDataStore {
    var worker: TaskListWorker
    var presenter: TaskListPresentLogic
    
    init(presenter: TaskListPresentLogic, worker: TaskListWorker) {
        self.presenter = presenter
        self.worker = worker
    }
}

extension TaskListInteractor: TaskListBusinessLogic {
    func fetchTasks() {
        let tasks = worker.getTasks()
        presenter.present(tasks: tasks)
    }
    
    func change(editingMode: Bool, animated: Bool) {
        worker.isEditingMode = editingMode
        presenter.set(editingMode: editingMode)
    }
    
    func select(task: Task) {
        presenter.presentDetail(of: task)
    }
}
