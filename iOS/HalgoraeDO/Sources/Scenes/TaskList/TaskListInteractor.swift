//
//  TaskListInteractor.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import Foundation

protocol TaskListBusinessLogic {
    func fetchTasks(request: TaskListModels.FetchTasks.Request)
    func changeFinish(request: TaskListModels.FinishTask.Request)
}

protocol TaskListDataStore {
    var taskList: TaskList { get }
}

class TaskListInteractor: TaskListDataStore {
    var worker: TaskListWorker
    var presenter: TaskListPresentLogic
    var taskList = TaskList()
    
    init(presenter: TaskListPresentLogic, worker: TaskListWorker) {
        self.presenter = presenter
        self.worker = worker
    }
}

extension TaskListInteractor: TaskListBusinessLogic {
    
    func fetchTasks(request: TaskListModels.FetchTasks.Request) {
        taskList.tasks = worker.getTasks()
        presenter.presentFetchTasks(response: TaskListModels.FetchTasks.Response(tasks: taskList.tasks))
    }
    
    func changeFinish(request: TaskListModels.FinishTask.Request) {
        let viewModels = request.displayedTasks
        viewModels.forEach { viewModel in
            let task = taskList.task(identifier: viewModel.id, postion: viewModel.position, parentPosition: viewModel.parentPosition)
            task.isCompleted = viewModel.isCompleted
            worker.changeFinish(task: task, postion: viewModel.position, parentPosition: viewModel.parentPosition)
        }
        presenter.presentFinshChanged(response: .init(tasks: taskList.tasks))
    }
}
