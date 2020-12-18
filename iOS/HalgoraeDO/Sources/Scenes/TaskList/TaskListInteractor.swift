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
    func updateComplete(request: TaskListModels.FinishTask.Request)
    func updateCompleteAll(request: TaskListModels.FinishTask.Request, projectId: String)
    func createTask(request: TaskListModels.CreateTask.Request)
    func createSection(request: TaskListModels.CreateSection.Request)
    func dragDropForList(requset: TaskListModels.DragDropTask.RequestForList)
    func dragDropForBoard(requset: TaskListModels.DragDropTask.RequestForBoard)
    func fetchDragDrop(request: TaskListModels.MoveTask.Request)
}

protocol TaskListDataStore {
    var taskList: TaskList { get }
}

class TaskListInteractor: TaskListDataStore {
    var worker: TaskListWorker
    var presenter: TaskListPresentLogic
    var taskList = TaskList()
    let dragDropInteractor: TaskDragDropInteractor
    
    init(presenter: TaskListPresentLogic, worker: TaskListWorker) {
        self.presenter = presenter
        self.worker = worker
        self.dragDropInteractor = TaskDragDropInteractor(presenter: presenter)
    }
}

extension TaskListInteractor: TaskListBusinessLogic {
    
    func fetchTasks(request: TaskListModels.FetchTasks.Request) {
        guard let id = request.projectId else { return }
        worker.request(endPoint: ProjectEndPoint.get(projectId: id)) { [weak self] (response: Response<Project>?) in
            self?.taskList.sections = response?.project?.sections?.array as? [Section] ?? []
            self?.presenter.presentFetchTasks(response: TaskListModels.FetchTasks.Response(sections: self?.taskList.sections ?? []))
        }
    }
    
    func fetchTasksForComplete(request: TaskListModels.FetchTasks.Request) {
        guard let id = request.projectId else { return }
        worker.request(endPoint: ProjectEndPoint.get(projectId: id)) { [weak self] (response: Response<Project>?) in
            self?.taskList.sections = response?.project?.sections?.array as? [Section] ?? []
            self?.presenter.presentFetchTasksForAll(response: TaskListModels.FetchTasks.Response(sections: self?.taskList.sections ?? []))
        }
    }
    
    func updateComplete(request: TaskListModels.FinishTask.Request) {
        let viewModels = request.displayedTasks
        viewModels.forEach { viewModel in
            guard let data = TaskListModels.TaskUpdateFields(title: viewModel.title, isDone: viewModel.isCompleted).encodeData else { return }
            worker.request(endPoint: TaskEndPoint.taskUpdate(id: viewModel.id, task: data)) { (project: Response<String>?) in }
        }
        let tasks = taskList.tasks(taskVMs: viewModels)
        presenter.presentFinshChanged(response: .init(tasks: tasks))
    }
    
    func updateCompleteAll(request: TaskListModels.FinishTask.Request, projectId: String) {
        var viewModels = request.displayedTasks
        let lastItem = viewModels.popLast()
        viewModels.forEach { viewModel in
            guard let data = TaskListModels.TaskUpdateFields(title: viewModel.title, isDone: viewModel.isCompleted).encodeData else { return }
            worker.request(endPoint: TaskEndPoint.taskUpdate(id: viewModel.id, task: data)) { (project: Response<String>?) in }
        }
        guard let viewModel = lastItem,
              let data = TaskListModels.TaskUpdateFields(title: viewModel.title, isDone: viewModel.isCompleted).encodeData
        else {
            return
        }
        
        worker.requestAndRequest(endPoint: TaskEndPoint.taskUpdate(id: viewModel.id, task: data),
                                     endPoint: ProjectEndPoint.get(projectId: projectId)) { [weak self] (response: Response<Project>?) in
            self?.taskList.sections = response?.project?.sections?.array as? [Section] ?? []
            self?.presenter.presentFetchTasks(response: TaskListModels.FetchTasks.Response(sections: self?.taskList.sections ?? []))
        }
        
    }
    
    func createTask(request: TaskListModels.CreateTask.Request) {
        guard let data = request.taskFields.encodeData else { return }
        let taskCreateEndpoint = TaskEndPoint.create(projectId: request.projectId,
                                                 sectionId: request.sectionId,
                                                 request: data)
        worker.requestAndRequest(endPoint: taskCreateEndpoint,
                                     endPoint: ProjectEndPoint.get(projectId: request.projectId)) { [weak self] (response: Response<Project>?) in
            self?.taskList.sections = response?.project?.sections?.array as? [Section] ?? []
            self?.presenter.presentFetchTasks(response: TaskListModels.FetchTasks.Response(sections: self?.taskList.sections ?? []))
        }
    }
    
    func createSection(request: TaskListModels.CreateSection.Request) {
        guard let data = request.sectionFields.encodeData else { return }
        let sectionCreateEndPoint = TaskEndPoint.sectionCreate(projectId: request.projectId,
                                                               request: data)
        worker.requestAndRequest(endPoint: sectionCreateEndPoint,
                                     endPoint: ProjectEndPoint.get(projectId: request.projectId)) { [weak self] (response: Response<Project>?) in
            self?.taskList.sections = response?.project?.sections?.array as? [Section] ?? []
            self?.presenter.presentFetchTasks(response: TaskListModels.FetchTasks.Response(sections: self?.taskList.sections ?? []))
        }
    }
    
    func dragDropForList(requset: TaskListModels.DragDropTask.RequestForList) {
       let apiEndPoint = dragDropInteractor.dropHelperForList(projectId: requset.projectId, childCheck: requset.childCheck, sourceIndexPath: requset.sourceIndexPath, destinationIndexPath: requset.destinationIndexPath, dataSource: requset.dataSource, destinationCell: requset.destinationCell)
        guard let endPoint = apiEndPoint else { return }
        fetchDragDrop(request: endPoint)
    }
    
    func dragDropForBoard(requset: TaskListModels.DragDropTask.RequestForBoard) {
        let apiEndPoint = dragDropInteractor.dropHelperForBoard(projectId: requset.projectId, sectionViewModel: requset.sectionViewModel, sourceSection: requset.sourceSection, destinationSection: requset.destinationSection, sourceTask: requset.sourceTask, destinationTask: requset.destinationTask)
        guard let endPoint = apiEndPoint else { return }
        fetchDragDrop(request: endPoint)
    }
    
    func fetchDragDrop(request: TaskListModels.MoveTask.Request) {
        guard let moveSectionData = request.taskMoveSection.encodeData,
              let taskMoveData = request.taskMoveFields.encodeData
        else { return }
        
        guard let projectId = request.projectId else {//task 하위에
            guard let parentTaskId = request.parentTaskId else { return }
            worker.requestAndRequest(endPoint: TaskEndPoint.taskUpdate(id: request.taskId, task: moveSectionData), endPoint: TaskEndPoint.moveIntoTask(taskId: parentTaskId, request: taskMoveData)){ (response: Response<String>?) in
            }
            return
        }
        
        worker.requestPatchAndPatch(patch: TaskEndPoint.taskUpdate(id: request.taskId, task: moveSectionData), endPoint: TaskEndPoint.moveIntoSection(projectId: projectId, sectionId: request.sectionId, request: taskMoveData)){ (response: Response<String>?) in
        }//섹션의 root items모두 전송
    }
}
