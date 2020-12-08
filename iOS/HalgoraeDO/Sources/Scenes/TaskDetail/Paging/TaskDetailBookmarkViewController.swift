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

    private var interactor: TaskDetailBusinessLogic?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func configure(interactor: TaskDetailBusinessLogic) {
        self.interactor = interactor
    }
}

extension TaskDetailBookmarkViewController: TaskDetailBookmarkDisplayLogic {
    
}
