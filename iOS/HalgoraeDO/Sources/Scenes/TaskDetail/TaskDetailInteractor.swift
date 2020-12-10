//
//  TaskDetailInteractor.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/01.
//

import Foundation

protocol TaskDetailBusinessLogic {
    func fetchSubTasks(request: TaskDetailModels.FetchSubTasks.Request)
    func fetchComments(request: TaskDetailModels.FetchComments.Request)
}

protocol TaskDetailDataStore {
    
}

class TaskDetailInteractor: TaskDetailDataStore {
    
    var presenter: TaskDetailPresentLogic
    var worker: TaskDetailWorker
    
    init(presenter: TaskDetailPresentLogic, worker: TaskDetailWorker) {
        self.presenter = presenter
        self.worker = worker
    }
}

extension TaskDetailInteractor: TaskDetailBusinessLogic {
    func fetchSubTasks(request: TaskDetailModels.FetchSubTasks.Request) {
        
        worker.request(endPoint: TaskEndPoint.get(taskId: request.id)) { [weak self] (tasks: [Task]?) in
            self?.presenter.presentFetchedTasks(response: .init(tasks: tasks ?? []))
        }
    }
    func fetchComments(request: TaskDetailModels.FetchComments.Request) {
        worker.requestComments(endPoint: .get(taskId: request.id)) { [weak self] (tasks: [Task]?, error) in
        worker.request(endPoint: CommentEndPoint.get(taskId: request.id)) { [weak self] (tasks: [Task]?) in
            self?.presenter.presentFetchedTasks(response: .init(tasks: tasks ?? []))
        }
        
    }
    
}
