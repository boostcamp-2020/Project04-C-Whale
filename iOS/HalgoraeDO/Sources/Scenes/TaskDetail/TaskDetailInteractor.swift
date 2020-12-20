//
//  TaskDetailInteractor.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/01.
//

import Foundation

protocol TaskDetailBusinessLogic {
    func fetchSubTasks(task: [Task])
    func fetchComments(request: TaskDetailModels.FetchComments.Request)
    func fetchBookmarks(request: TaskDetailModels.FetchBookmarks.Request)
    func createComment(request: TaskDetailModels.CreateComment.Request)
    func createBookmark(request: TaskDetailModels.CreateBookmark.Request)
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
        worker.request(endPoint: CommentEndPoint.get(taskId: request.id)) { [weak self] (response: Response<[Comment]>?) in
            self?.presenter.presentFetchedComments(response: .init(comments: response?.comments ?? []))
        }
    }
    
    func createComment(request: TaskDetailModels.CreateComment.Request) {
        let fields = request.commentFields
        guard let data = fields.encodeData else { return }
        
        worker.requestPostAndGet(post: CommentEndPoint.create(taskId: request.taskId, request: data), get: CommentEndPoint.get(taskId: request.taskId)) { [weak self] (response: Response<[Comment]>?) in
            self?.presenter.presentFetchedComments(response: .init(comments: response?.comments ?? []))
        }
    }
    
    func fetchBookmarks(request: TaskDetailModels.FetchBookmarks.Request) {
        worker.request(endPoint: BookmarkEndPoint.get(taskId: request.id)) { [weak self] (response: Response<[Bookmark]>?) in
            self?.presenter.presentFetchedBookmarks(response: .init(bookmakrs: response?.bookmarks ?? []))
        }
    }
    
    func createBookmark(request: TaskDetailModels.CreateBookmark.Request) {
        let fields = request.bookmarkFields
        guard let data = fields.encodeData else { return }
        
        worker.requestPostAndGet(post: BookmarkEndPoint.create(taskId: request.taskId, request: data), get: BookmarkEndPoint.get(taskId: request.taskId)) { [weak self] (response: Response<[Bookmark]>?) in
            self?.presenter.presentFetchedBookmarks(response: .init(bookmakrs: response?.bookmarks ?? []))
        }
  
    }
    
    func fetchSubTasks(task: [Task]) {
        presenter.presentFetchedTasks(response: .init(tasks: task))
    }
    
    func updateTask(request: TaskListModels.ReorderTask.Request) {
        let viewModel = request.displayedTask
        
        guard let data = viewModel.encodeData else { return }
        worker.request(endPoint: TaskEndPoint.taskUpdate(id: request.taskId, task: data)) { (project: Project?) in }
    }
}
