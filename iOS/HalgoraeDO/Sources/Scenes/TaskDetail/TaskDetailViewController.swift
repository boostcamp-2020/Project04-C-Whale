//
//  TaskDetailViewController.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/01.
//

import UIKit

protocol TaskDetailDisplayLogic: class {
    
}

class TaskDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private var task: Task
    private var interactor: TaskDetailBusinessLogic?
    private var priority: Priority = .four {
        didSet {
            priorityButton.tintColor = priority.color
        }
    }
    lazy var pageViewControllers: [UIViewController] = {
        var pages: [UIViewController] = []
        pages.append(instance(name: "\(TaskDetailBookmarkViewController.self)"))
        pages.append(instance(name: "\(TaskDetailCommentViewController.self)"))
        if task.parentId == nil {
            pages.append(instance(name: "\(TaskDetailSubTasksViewController.self)"))
        }
        return pages
    }()
    
    // MARK: Views

    @IBOutlet weak private var pageSegmentsControl: UISegmentedControl!
    @IBOutlet weak private var navigationView: UIView!
    @IBOutlet weak private var navigationBar: UINavigationBar!
    @IBOutlet weak private var saveBarButtomItem: UIBarButtonItem!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var taskTitleTextView: UITextView!
    @IBOutlet weak private var finishButton: UIButton!
    @IBOutlet weak private var priorityButton: UIButton!
    @IBOutlet weak private var datePickerButtonView: DatePickerButtonView!
    weak private var pageViewController: UIPageViewController?
    
    // MARK: View Life Cycle
    
    init?(coder: NSCoder, task: Task) {
        self.task = task
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        self.task = Task(context: Storage().childContext)
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureLogic()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Initialize
    
    private func configureLogic() {
        
        let taskDetailBookmarkViewController =  pageViewControllers[0] as? TaskDetailBookmarkViewController
        let taskDetailCommentViewController =  pageViewControllers[1] as? TaskDetailCommentViewController
        let taskDetailSubTasksViewController = pageViewControllers.last as? TaskDetailSubTasksViewController
        
        let presenter: TaskDetailPresenter = TaskDetailPresenter(viewController: self, subTaskViewController: taskDetailSubTasksViewController, subTaskCommentViewController: taskDetailCommentViewController, subTaskBookmarkViewController: taskDetailBookmarkViewController)
        
        let interactor = TaskDetailInteractor(presenter: presenter, worker: TaskDetailWorker(sessionManager: SessionManager(configuration: .default)))
        taskDetailSubTasksViewController?.configure(interactor: interactor, task: task)
        taskDetailCommentViewController?.configure(interactor: interactor, task: task)
        taskDetailBookmarkViewController?.configure(interactor: interactor, task: task)
        self.interactor = interactor
        
        if task.parentId != nil {
            pageSegmentsControl.removeSegment(at: 0, animated: false)
            pageSegmentsControl.selectedSegmentIndex = 0
        }
    }
    
    private func setup() {
        taskTitleTextView.delegate = self
        titleLabel.text = "할일 수정하기"
        taskTitleTextView.text = task.title
        priority = task.priority 
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        set(editing)
    }
    
    // MARK: - Methods
    
    private func set(_ editingMode: Bool) {
        saveBarButtomItem.isEnabled = task.title != taskTitleTextView.text
        navigationView.isHidden = editingMode
        navigationBar.isHidden = !editingMode
        finishButton.isEnabled = !editingMode
    }
    
    private func configure(popover: PopoverViewController) {
        popover.modalPresentationStyle = .popover
        popover.popoverPresentationController?.delegate = self
        popover.viewModels = Priority.allCases.map { $0.viewModel() }
        popover.selectHandler = { indexPath in
            self.priority = Priority.allCases[indexPath.row]
            popover.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: IBActions
    
    @IBAction func didTabCancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapCancelBarButtonItem(_ sender: UIBarButtonItem) {
        setEditing(false, animated: true)
        view.endEditing(true)
    }
    
    @IBAction private func didTapSaveBarButtonItem(_ sender: UIBarButtonItem) {
        guard let taskTitle = taskTitleTextView.text else { return }

        interactor?.updateTask(request: .init(taskId: task.id, displayedTask: .init(title: taskTitle, isDone: task.isDone, dueDate: "\(datePickerButtonView.date)", priority: "\(priority.rawValue)")))
        
        let taskListViewController = (self.presentingViewController as? UINavigationController)?.viewControllers.last
        dismiss(animated: true) {
            taskListViewController?.viewWillAppear(true)
        }
    }
    
    @IBAction func didTapSegmentControl(_ sender: UISegmentedControl) {
        var tempPageViewControllers = pageViewControllers
        tempPageViewControllers.reverse()
        pageViewController?.setViewControllers([tempPageViewControllers[sender.selectedSegmentIndex]], direction: .reverse, animated: false, completion: nil)
    }
    
    // MARK: - Navigation
    
    private func instance(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: name)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pagingVC = segue.destination as? TaskDetailPageViewController {

            pagingVC.delegate = self
            pagingVC.pages = pageViewControllers.reversed()
            pageViewController = pagingVC
        } else if let popoverVC = segue.destination as? PopoverViewController {
            configure(popover: popoverVC)
        }
    }
}

// MARK: - UITextViewDelegate

extension TaskDetailViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        setEditing(true, animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        saveBarButtomItem.isEnabled = task.title != textView.text
    }
}

// MARK: - UIPopoverPresentationControllerDelegate

extension TaskDetailViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK: - UIPageViewControllerDelegate

extension TaskDetailViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        var tempPageViewControllers = pageViewControllers
        tempPageViewControllers.reverse()
        guard let currentVC = pageViewController.viewControllers?.first,
            let currentIndex = tempPageViewControllers.firstIndex(of: currentVC)
        else {
            return
        }
        pageSegmentsControl.selectedSegmentIndex = currentIndex
    }
}

extension TaskDetailViewController: TaskDetailDisplayLogic {
    
}
