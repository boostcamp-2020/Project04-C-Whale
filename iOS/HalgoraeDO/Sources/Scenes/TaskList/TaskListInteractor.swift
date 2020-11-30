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
        let tasks = worker.getTasks()
        presenter.presentFetchTasks(response: TaskListModels.FetchTasks.Response(tasks: tasks))
    }
    
    func changeFinish(request: TaskListModels.FinishTask.Request) {
        let viewModels = request.displayedTasks
        let tasks = viewModels.map { (viewModel: TaskListModels.DisplayedTask) -> Task in
            let task = taskList.task(identifier: viewModel.id, postion: viewModel.position, parentPosition: viewModel.parentPosition)
            task.isCompleted = viewModel.isCompleted
            worker.changeFinish(task: task, postion: viewModel.position, parentPosition: viewModel.parentPosition)
            return task
        }
        presenter.presentFinshChanged(response: .init(tasks: tasks))
    }
    
}
