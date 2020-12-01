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
    
    private var task: Task
    
    // MARK: Views

    @IBOutlet weak private var navigationView: UIView!
    @IBOutlet weak private var navigationBar: UINavigationBar!
    @IBOutlet weak private var saveBarButtomItem: UIBarButtonItem!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var taskTitleTextView: UITextView!
    @IBOutlet weak private var subContainerView: UIView!
    
    // MARK: View Life Cycle
    
    init?(coder: NSCoder, task: Task) {
        self.task = task
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        self.task = Task(title: "")
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Initialize
    
    private func setup() {
        taskTitleTextView.delegate = self
        titleLabel.text = "Project"
        taskTitleTextView.text = task.title
    }
    
    // MARK: - Methods
    
    private func set(editingMode: Bool) {
        saveBarButtomItem.isEnabled = task.title != taskTitleTextView.text
        navigationView.isHidden = editingMode
        navigationBar.isHidden = !editingMode
    }
    
    // MARK: IBActions
    
    @IBAction private func didTapCancelBarButtonItem(_ sender: UIBarButtonItem) {
        set(editingMode: false)
        view.endEditing(true)
    }
    
    @IBAction private func didTapSaveBarButtonItem(_ sender: UIBarButtonItem) {
        
    }
    
    
    @IBAction private func didTapTaskFinishButton(_ sender: UIButton) {
        
    }
    
    @IBAction private func didTapSubTasksTabButton(_ sender: UIButton) {
        
    }
    
    @IBAction private func didTapCommentTabButton(_ sender: UIButton) {
        
    }
    
    @IBAction private func didTapBookmarkButton(_ sender: UIButton) {
        
    }
}

// MARK: - TaskDetail DisplayLogic

extension TaskDetailViewController: TaskDetailDisplayLogic {
    
}

// MARK: - UITextViewDelegate

extension TaskDetailViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        set(editingMode: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        saveBarButtomItem.isEnabled = task.title != textView.text
    }
}
