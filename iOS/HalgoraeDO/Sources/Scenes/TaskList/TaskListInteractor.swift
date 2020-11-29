//
//  TaskListInteractor.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import Foundation

protocol TaskListBusinessLogic {
    func fetchTasks(request: TaskListModels.FetchTasks.Request)
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
    func fetchTasks(request: TaskListModels.FetchTasks.Request) {
        let tasks = worker.getTasks()
        presenter.presentFetchTasks(response: TaskListModels.FetchTasks.Response(tasks: tasks))
    }
}
