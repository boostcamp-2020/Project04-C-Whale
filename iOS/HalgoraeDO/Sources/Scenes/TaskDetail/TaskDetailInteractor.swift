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
        
    func createComment(request: TaskDetailModels.CreateComment.Request) {
        let fields = request.commentFields
        guard let data = fields.text.encodeData else { return }
        worker.requestPostAndGet(post: CommentEndPoint.create(taskId: fields.taskId, request: data),
                                 get: CommentEndPoint.get(taskId: fields.taskId)) { [weak self] (comments: [Comment]?) in
            self?.presenter.presentFetchedComments(response: .init(comments: comments ?? []))
        }
    }
}
