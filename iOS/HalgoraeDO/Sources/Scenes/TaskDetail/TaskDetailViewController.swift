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
    private var currentTabIndex = 0 {
        didSet {
            subTabStackView
                .arrangedSubviews
                .compactMap({$0 as? UIButton})
                .enumerated()
                .forEach { $0.element.isSelected = $0.offset == currentTabIndex }
        }
    }
    lazy var pages: [UIViewController] = {
        return [
            instance(name: "\(TaskDetailSubTasksViewController.self)"),
            instance(name: "\(TaskDetailCommentViewController.self)"),
            instance(name: "\(TaskDetailBookmarkViewController.self)"),
        ]
    }()
    
    // MARK: Views

    @IBOutlet weak private var navigationView: UIView!
    @IBOutlet weak private var navigationBar: UINavigationBar!
    @IBOutlet weak private var saveBarButtomItem: UIBarButtonItem!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var taskTitleTextView: UITextView!
    @IBOutlet weak private var finishButton: UIButton!
    @IBOutlet weak private var priorityButton: UIButton!
    @IBOutlet weak var subTaskTabButton: UIButton!
    @IBOutlet weak var commentTabButton: UIButton!
    @IBOutlet weak var bookmarkTabButton: UIButton!
    @IBOutlet weak var subTabStackView: UIStackView!
    weak var pageViewController: UIPageViewController?
    
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
    
    private func configureLogic() {
        let taskDetailSubTasksViewController = pages[0] as? TaskDetailSubTasksViewController
        let taskDetailCommentViewController = pages[1] as? TaskDetailCommentViewController
        let taskDetailBookmarkViewController = pages[2] as? TaskDetailBookmarkViewController
        let presenter: TaskDetailPresenter = TaskDetailPresenter(viewController: self,
                                            subTaskViewController: taskDetailSubTasksViewController,
                                            subTaskCommentViewController: taskDetailCommentViewController,
                                            subTaskBookmarkViewController: taskDetailBookmarkViewController)
        let interactor = TaskDetailInteractor(presenter: presenter, worker: TaskDetailWorker(sessionManager: SessionManager(configuration: .default)))
        taskDetailSubTasksViewController?.configure(interactor: interactor)
        taskDetailCommentViewController?.configure(interactor: interactor)
        taskDetailBookmarkViewController?.configure(interactor: interactor)
        self.interactor = interactor
    }
    
    private func setup() {
        taskTitleTextView.delegate = self
        titleLabel.text = "Project"
        taskTitleTextView.text = task.title
        priority = task.priority ?? .four
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
    
    @IBAction private func didTapCancelBarButtonItem(_ sender: UIBarButtonItem) {
        setEditing(false, animated: true)
        view.endEditing(true)
    }
    
    @IBAction private func didTapSaveBarButtonItem(_ sender: UIBarButtonItem) {
        
    }
    
    
    @IBAction private func didTapTaskFinishButton(_ sender: UIButton) {
        
    }
    
    @IBAction private func didTapSubTasksTabButton(_ sender: UIButton) {
        let tabIndex = 0
        let direection: UIPageViewController.NavigationDirection = currentTabIndex == 2 ? .forward : .reverse
        pageViewController?.setViewControllers([pages[tabIndex]], direction: direection, animated: true, completion: nil)
        currentTabIndex = tabIndex
    }
    
    @IBAction private func didTapCommentTabButton(_ sender: UIButton) {
        let tabIndex = 1
        let direection: UIPageViewController.NavigationDirection = currentTabIndex < tabIndex ? .forward : .reverse
        pageViewController?.setViewControllers([pages[tabIndex]], direction: direection, animated: true, completion: nil)
        currentTabIndex = tabIndex
    }
    
    @IBAction private func didTapBookmarkButton(_ sender: UIButton) {
        let tabIndex = 2
        let direection: UIPageViewController.NavigationDirection = .forward
        pageViewController?.setViewControllers([pages[tabIndex]], direction: direection, animated: true, completion: nil)
        currentTabIndex = tabIndex
    }
    
    // MARK: - Navigation
    
    private func instance(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: name)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pagingVC = segue.destination as? TaskDetailPageViewController {
            pageViewController = pagingVC
            pagingVC.delegate = self
            pagingVC.pages = pages
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
        guard let currentVC = pageViewController.viewControllers?.first,
            let currentIndex = pages.firstIndex(of: currentVC)
        else {
            return
        }
        
        currentTabIndex = currentIndex
    }
}

extension TaskDetailViewController: TaskDetailDisplayLogic {
    
}
