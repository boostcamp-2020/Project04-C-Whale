//
//  TaskDetailCommentViewController.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/01.
//

import UIKit

protocol TaskDetailCommentDisplayLogic: class {
    
}

class TaskDetailCommentViewController: UIViewController {

    private var interactor: TaskDetailBusinessLogic?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func configure(interactor: TaskDetailBusinessLogic) {
        self.interactor = interactor
    }
}

extension TaskDetailCommentViewController: TaskDetailCommentDisplayLogic {
    
}
