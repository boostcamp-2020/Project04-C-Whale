//
//  TaskListInteractor.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import Foundation

protocol TaskListBusinessLogic {
    func fetchTasks(request: TaskListModels.FetchTasks.Request)
    func fetchTasksForComplete(request: TaskListModels.FetchTasks.Request)
    func changeFinish(request: TaskListModels.FinishTask.Request)
    func changeFinishForAll(request: TaskListModels.FinishTask.Request, projectId: String)
    func createTask(request: TaskListModels.CreateTask.Request)
    func createSection(request: TaskListModels.CreateSection.Request)
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
        guard let id = request.projectId else { return }
        worker.request(endPoint: .get(projectId: id)) { [weak self] (project: Project?) in
            self?.taskList.sections = project?.sections?.array as? [Section] ?? []
            self?.presenter.presentFetchTasks(response: TaskListModels.FetchTasks.Response(sections: self?.taskList.sections ?? []))
        }
    }
    
    func fetchTasksForComplete(request: TaskListModels.FetchTasks.Request) {
        guard let id = request.projectId else { return }
        worker.request(endPoint: .get(projectId: id)) { [weak self] (project: Project?) in
            self?.taskList.sections = project?.sections?.array as? [Section] ?? []
            self?.presenter.presentFetchTasksForAll(response: TaskListModels.FetchTasks.Response(sections: self?.taskList.sections ?? []))
        }
    }
    
    func changeFinish(request: TaskListModels.FinishTask.Request) {
        let viewModels = request.displayedTasks
        viewModels.forEach { viewModel in
            guard let data = TaskListModels.TaskUpdateFields(title: viewModel.title, isDone: viewModel.isCompleted).encodeData else { return }
            worker.requestPatch(endPoint: TaskEndPoint.taskUpdate(id: viewModel.id, task: data)) { (project: Project?) in }
        }
        presenter.presentFinshChanged(response: .init(tasks: taskList.tasks))
    }
    
    func changeFinishForAll(request: TaskListModels.FinishTask.Request, projectId: String) {
        var viewModels = request.displayedTasks
        let lastItem = viewModels.popLast()
        viewModels.forEach { viewModel in
            guard let data = TaskListModels.TaskUpdateFields(title: viewModel.title, isDone: viewModel.isCompleted).encodeData else { return }
            worker.requestPatch(endPoint: TaskEndPoint.taskUpdate(id: viewModel.id, task: data)) { (project: Project?) in }
          
        }
        guard let viewModel = lastItem,
              let data = TaskListModels.TaskUpdateFields(title: viewModel.title, isDone: viewModel.isCompleted).encodeData
        else {
            return
        }
        worker.requestPostAndGetTask(post: TaskEndPoint.taskUpdate(id: viewModel.id, task: data), endPoint: .get(projectId: projectId)) { [weak self] (project: Project?) in
            self?.taskList.sections = project?.sections?.array as? [Section] ?? []
            self?.presenter.presentFetchTasks(response: TaskListModels.FetchTasks.Response(sections: self?.taskList.sections ?? []))
        }
    }
    
    func createTask(request: TaskListModels.CreateTask.Request) {
        guard let data = request.taskFields.encodeData else { return }
        worker.requestPostAndGetTask(post: TaskEndPoint.create(projectId: request.projectId, sectionId: request.sectionId, request: data), endPoint: .get(projectId: request.projectId)) { [weak self] (project: Project?) in
            self?.taskList.sections = project?.sections?.array as? [Section] ?? []
            self?.presenter.presentFetchTasks(response: TaskListModels.FetchTasks.Response(sections: self?.taskList.sections ?? []))
        }
    }
    
    func createSection(request: TaskListModels.CreateSection.Request) {
        guard let data = request.sectionFields.encodeData else { return }
        worker.requestPostAndGetTask(post: TaskEndPoint.sectionCreate(projectId: request.projectId, request: data), endPoint: .get(projectId: request.projectId)) { [weak self] (project: Project?) in
            self?.taskList.sections = project?.sections?.array as? [Section] ?? []
            self?.presenter.presentFetchTasks(response: TaskListModels.FetchTasks.Response(sections: self?.taskList.sections ?? []))
        }
    }
}
