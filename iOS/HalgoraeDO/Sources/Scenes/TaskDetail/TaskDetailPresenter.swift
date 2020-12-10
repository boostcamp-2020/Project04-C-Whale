//
//  TaskDetailPresenter.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/01.
//

import Foundation

protocol TaskDetailPresentLogic {
    func presentFetchedTasks(response: TaskDetailModels.FetchSubTasks.Response)
    func presentFetchedComments(response: TaskDetailModels.FetchComments.Response)
}

class TaskDetailPresenter {
    
    weak var viewController: TaskDetailDisplayLogic?
    weak var subTaskViewController: TaskDetailSubTasksDisplayLogic?
    weak var subTaskCommentViewController: TaskDetailCommentDisplayLogic?
    weak var subTaskBookmarkViewController: TaskDetailBookmarkDisplayLogic?
    
    init(viewController: TaskDetailDisplayLogic,
         subTaskViewController: TaskDetailSubTasksDisplayLogic?,
         subTaskCommentViewController: TaskDetailCommentDisplayLogic?,
         subTaskBookmarkViewController: TaskDetailBookmarkDisplayLogic?) {
        
        self.viewController = viewController
        self.subTaskViewController = subTaskViewController
        self.subTaskCommentViewController = subTaskCommentViewController
        self.subTaskBookmarkViewController = subTaskBookmarkViewController
    }
}

extension TaskDetailPresenter: TaskDetailPresentLogic {
    
    func presentFetchedTasks(response: TaskDetailModels.FetchSubTasks.Response) {
        let taskVMs = response.tasks.compactMap { TaskListModels.DisplayedTask(task: $0) }
        subTaskViewController?.displaySubTasks(viewModel: .init(taskVMs: taskVMs))
    }
    
    func presentFetchedComments(response: TaskDetailModels.FetchComments.Response) {
        let comemntVMs = response.comments.compactMap { TaskDetailModels.CommentVM(comment: $0) }
        subTaskCommentViewController?.displayFetchedComments(viewModel: .init(commentVMs: comemntVMs))
    }
}
