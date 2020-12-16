//
//  TaskDetailSubTasksViewController.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/01.
//

import UIKit

protocol TaskDetailSubTasksDisplayLogic: class {
    func displaySubTasks(viewModel: TaskDetailModels.FetchSubTasks.ViewModel)
}

class TaskDetailSubTasksViewController: UIViewController {
    
    // MARK: - Properties
    
    private var task: Task?
    private var dataSource: UICollectionViewDiffableDataSource<String, TaskListModels.TaskVM>! = nil
    private var interactor: TaskDetailBusinessLogic?
    
    // MARK: Views
    
    @IBOutlet weak var subTaskCollectionView: UICollectionView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let task = task else { return }
        let tasks = task.tasks?.array as? [Task] ?? []
        interactor?.fetchSubTasks(task: tasks)
    }
    
    // MARK: - Initialize
    
    func configure(interactor: TaskDetailBusinessLogic, task: Task) {
        self.interactor = interactor
        self.task = task
        let tasks = task.tasks?.array as? [Task] ?? []
        interactor.fetchSubTasks(task: tasks)
    }
}

// MARK: - Configure CollectionView Layout

private extension TaskDetailSubTasksViewController {
    
    func configureCollectionView() {
        subTaskCollectionView.collectionViewLayout = generateLayout()
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        
        return layout
    }
}

// MARK: - Configure CollectionView Data Source

private extension TaskDetailSubTasksViewController {
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TaskCollectionViewListCell, TaskListModels.TaskVM> { (cell, _: IndexPath, taskItem) in
            cell.taskViewModel = taskItem
            cell.finishHandler = { [weak self] task in
                guard let self = self else { return }
                // self.interactor?.changeFinish(request: .init(displayedTasks: [task]))
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<String, TaskListModels.TaskVM>(collectionView: subTaskCollectionView, cellProvider: { (collectionView, indexPath, task) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: task)
        })
    }
    
    func generateSnapshot(taskItems: [TaskListModels.TaskVM]) -> NSDiffableDataSourceSectionSnapshot<TaskListModels.TaskVM> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<TaskListModels.TaskVM>()
        func addItems(_ taskItems: [TaskListModels.TaskVM], to parent: TaskListModels.TaskVM?) {
            snapshot.append(taskItems, to: parent)
            for taskItem in taskItems where !taskItem.subItems.isEmpty {
                addItems(taskItem.subItems, to: taskItem)
                snapshot.expand([taskItem])
            }
        }
        addItems(taskItems, to: nil)
        
        return snapshot
    }
}

extension TaskDetailSubTasksViewController: TaskDetailSubTasksDisplayLogic {
    func displaySubTasks(viewModel: TaskDetailModels.FetchSubTasks.ViewModel) {
        let sectionSnapshot = generateSnapshot(taskItems: viewModel.taskVMs)
        dataSource?.apply(sectionSnapshot, to: "")
    }
}
