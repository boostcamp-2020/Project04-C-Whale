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
    func deSelect(task: Task)
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
        guard !worker.isEditingMode else {
            worker.append(selected: task)
            presenter.present(numberOfSelectedTasks: worker.selectedTasks.count)
            return
        }
        presenter.presentDetail(of: task)
    }
    
    func deSelect(task: Task) {
        guard worker.isEditingMode else {
            return
        }

        worker.remove(selected: task)
        presenter.present(numberOfSelectedTasks: worker.selectedTasks.count)
    }
}
