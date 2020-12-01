//
//  TaskDetailViewController.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/01.
//

import UIKit

protocol TaskDetailDisplayLogic {
    
}

class TaskDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var task: Task
    
    // MARK: Views

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subContainerView: UIView!
    
    // MARK: View Life Cycle
    
    init?(coder: NSCoder, task: Task) {
        self.task = task
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("This ViewController must be init with useCase.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Project"
    }
    
    // MARK: - Methods
    
    // MARK: IBActions
    
    @IBAction private func didTapSubTasksTabButton(_ sender: UIButton) {
        
    }
    
    @IBAction private func didTapCommentTabButton(_ sender: UIButton) {
        
    }
    
    @IBAction private func didTapBookmarkButton(_ sender: UIButton) {
        
    }
}

extension TaskDetailViewController: TaskDetailDisplayLogic {
    
}
