//
//  TaskDetailBookmarkViewController.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/01.
//

import UIKit

protocol TaskDetailBookmarkDisplayLogic: class {
    
}

class TaskDetailBookmarkViewController: UIViewController {

    private var task: Task?
    private var interactor: TaskDetailBusinessLogic?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func configure(interactor: TaskDetailBusinessLogic, task: Task) {
        self.interactor = interactor
        self.task = task
    }
}

extension TaskDetailBookmarkViewController: TaskDetailBookmarkDisplayLogic {
    
}
