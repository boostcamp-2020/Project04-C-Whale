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
    func createComment(request: TaskDetailModels.CreateComment.Request)
    func updateTask(request: TaskListModels.ReorderTask.Request)
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
    
    func fetchComments(request: TaskDetailModels.FetchComments.Request) {
        
        worker.request(endPoint: CommentEndPoint.get(taskId: request.id)) { [weak self] (comments: [Comment]?) in
            self?.presenter.presentFetchedComments(response: .init(comments: comments ?? []))
        }
    }
    
    func createComment(request: TaskDetailModels.CreateComment.Request) {
        
        let fields = request.commentFields
        guard let data = fields.encodeData else { return }
        
        worker.requestPostAndGet(post: CommentEndPoint.create(taskId: request.taskId, request: data), get: CommentEndPoint.get(taskId: request.taskId)) { [weak self] (comments: [Comment]?) in
            self?.presenter.presentFetchedComments(response: .init(comments: comments ?? []))
        }
    }
    
    
    func fetchSubTasks(request: TaskDetailModels.FetchSubTasks.Request) {
        
//        worker.request(endPoint: TaskEndPoint.get(taskId: request.id)) { [weak self] (tasks: [Task]?) in
//            self?.presenter.presentFetchedTasks(response: .init(tasks: tasks ?? []))
//        }
        //TODO 임시 데이터 변경하기!
        let tasks = [
            Task(fields: .init(title: "1111", date: Date(), priority: "4"), context: Storage().childContext),
            Task(fields: .init(title: "1111", date: Date(), priority: "4"), context: Storage().childContext),
            Task(fields: .init(title: "1111", date: Date(), priority: "4"), context: Storage().childContext),
            Task(fields: .init(title: "1111", date: Date(), priority: "4"), context: Storage().childContext),
        ]
        presenter.presentFetchedTasks(response: .init(tasks: tasks))
    }
    
    func updateTask(request: TaskListModels.ReorderTask.Request) {
        let viewModel = request.displayedTask
        
        guard let data = viewModel.encodeData else { return }
        worker.request(endPoint: TaskEndPoint.taskUpdate(id: request.taskId, task: data)) { (project: Project?) in }
    }
}
