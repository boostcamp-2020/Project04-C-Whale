//
//  TaskListViewController.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import UIKit

protocol TaskListDisplayLogic {
    
}

class TaskListViewController: UIViewController {
    
    // MARK: Properties
    
    var interactor: TaskListBusinessLogic?
    var router: (TaskListRoutingLogic & TaskListDataPassing)?
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLogic()
    }
    
    // MARK: Initialize
    
    private func configureLogic() {
        
        let presenter = TaskListPresenter(viewController: self)
        let interactor = TaskListInteractor(presenter: presenter, worker: TaskListWorker())
        
        self.interactor = interactor
    }
    
    // MARK: IBActions
    
    @IBAction func didTapMoreButton(_ sender: UIBarButtonItem) {
        
    }
}

extension TaskListViewController: TaskListDisplayLogic {
    
}
