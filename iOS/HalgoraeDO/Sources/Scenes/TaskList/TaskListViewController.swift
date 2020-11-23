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
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let showBoardAction = UIAlertAction(title: "보드로 보기", style: .default) { (action) in
            
        }

        let addSectionAction = UIAlertAction(title: "섹션 추가", style: .default) { (action) in
            
        }

        let selectTaskAction = UIAlertAction(title: "작업 선택", style: .default) { (action) in
            
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (action) in
            
        }

        [showBoardAction, addSectionAction, selectTaskAction, cancelAction].forEach { alert.addAction($0) }
        present(alert, animated: true, completion: nil)
    }
}

extension TaskListViewController: TaskListDisplayLogic {
    
}
