//
//  TaskDetailPresenter.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/01.
//

import Foundation

protocol TaskDetailPresentLogic {
    
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
    
}
