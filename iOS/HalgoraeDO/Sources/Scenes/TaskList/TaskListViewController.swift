//
//  TaskListViewController.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import UIKit

protocol TaskListDisplayLogic {
    func display(tasks: [Task])
}

class TaskListViewController: UIViewController {
    
    // MARK: - Properties
    
    private var interactor: TaskListBusinessLogic?
    private var router: (TaskListRoutingLogic & TaskListDataPassing)?
    private var dataSource: UICollectionViewDiffableDataSource<String, Task>! = nil
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLogic()
        configureCollectionView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.fetchTasks()
    }
    
    // MARK: - Views
    
    @IBOutlet weak private var taskListCollectionView: UICollectionView!
    @IBOutlet weak var moreButton: UIBarButtonItem!
    @IBOutlet weak var addButton: RoundButton!
    @IBOutlet weak var editToolBar: UIToolbar!
    
    // MARK: - Initialize
    
    private func configureLogic() {
        let presenter = TaskListPresenter(viewController: self)
        let interactor = TaskListInteractor(presenter: presenter, worker: TaskListWorker())
        
        self.interactor = interactor
    }
    
    // MARK: - Methods
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        taskListCollectionView.isEditing = editing
        moreButton.title = editing ? "취소" : "More"
        addButton.isHidden = editing
        editToolBar.isHidden = !editing
    }
    
    // MARK: IBActions
    
    @IBAction private func didTapMoreButton(_ sender: UIBarButtonItem) {
        
        guard !isEditing else {
            setEditing(false, animated: true)
            return
        }
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let showBoardAction = UIAlertAction(title: "보드로 보기", style: .default) { (action) in
            
        }

        let addSectionAction = UIAlertAction(title: "섹션 추가", style: .default) { (action) in
            
        }

        let selectTaskAction = UIAlertAction(title: "작업 선택", style: .default) { [weak self] (action) in
            
            self?.setEditing(true, animated: true)
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (action) in
            
        }

        [showBoardAction, addSectionAction, selectTaskAction, cancelAction].forEach { alert.addAction($0) }
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didTapAddButton(_ sender: RoundButton) {
        
    }
}

// MARK: - TaskList Display Logic

extension TaskListViewController: TaskListDisplayLogic {
    func display(tasks: [Task]) {
        let snapShot = snapshot(taskItems: tasks)
        let sectionTitle = ""
        dataSource.apply(snapShot, to: sectionTitle, animatingDifferences: true)
    }
}

// MARK: - Configure CollectionView Layout

private extension TaskListViewController {
    private func configureCollectionView() {
        taskListCollectionView.collectionViewLayout = generateLayout()
        taskListCollectionView.allowsMultipleSelectionDuringEditing = true
    }
    
    private func generateLayout() -> UICollectionViewLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .sidebar)
        listConfiguration.leadingSwipeActionsConfigurationProvider = { indexPath in
            let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, view, completion) in
                if !(self?.isEditing ?? true) {
                    self?.setEditing(true, animated: true)
                }
                self?.taskListCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init())
            }
            return UISwipeActionsConfiguration(actions: [editAction])
        }
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        return layout
    }
}

// MARK: - Configure CollectionView Data Source

private extension TaskListViewController {

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TaskCollectionViewListCell, Task> { [weak self] (cell, indexPath, taskItem) in
            
            cell.task = taskItem
            cell.completeHandler = { [weak self] task in
                guard let self = self,
                      let task = task
                else {
                    return
                }
                
                var currentSnapshot = self.dataSource.snapshot()
                if task.isCompleted {
                    currentSnapshot.deleteItems([task])
                } else {
                }
                self.dataSource.apply(currentSnapshot)
            }
            
            let disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .automatic)
            cell.accessories = taskItem.subTasks.isEmpty ? [] : [.outlineDisclosure(options: disclosureOptions)]
        }
        
        self.dataSource = UICollectionViewDiffableDataSource<String, Task>(collectionView: taskListCollectionView, cellProvider: { (collectionView, indexPath, task) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: task)
        })
    }
    
    private func snapshot(taskItems: [Task]) -> NSDiffableDataSourceSectionSnapshot<Task> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<Task>()

        func addItems(_ taskItems: [Task], to parent: Task?) {
            snapshot.append(taskItems, to: parent)
            for taskItem in taskItems where !taskItem.subTasks.isEmpty {
                addItems(taskItem.subTasks, to: taskItem)
            }
        }

        addItems(taskItems, to: nil)
        return snapshot
    }
}
