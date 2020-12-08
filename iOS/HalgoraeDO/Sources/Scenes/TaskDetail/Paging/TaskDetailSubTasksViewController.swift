//
//  TaskDetailSubTasksViewController.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/01.
//

import UIKit

protocol TaskDetailSubTasksDisplayLogic: class {
    
}

class TaskDetailSubTasksViewController: UIViewController {
    
    typealias TaskVM = TaskListModels.DisplayedTask
    
    private var dataSource: UICollectionViewDiffableDataSource<String, TaskVM>! = nil
    private var interactor: TaskDetailBusinessLogic?
    
    @IBOutlet weak var subTaskCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
    }
    
    func configure(interactor: TaskDetailBusinessLogic) {
        self.interactor = interactor
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
        let cellRegistration = UICollectionView.CellRegistration<TaskCollectionViewListCell, TaskVM> { (cell, _: IndexPath, taskItem) in
            cell.taskViewModel = taskItem
            cell.finishHandler = { [weak self] task in
                guard let self = self else { return }
                // self.interactor?.changeFinish(request: .init(displayedTasks: [task]))
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<String, TaskVM>(collectionView: subTaskCollectionView, cellProvider: { (collectionView, indexPath, task) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: task)
        })
    }
    
    func snapshot(taskItems: [TaskVM]) -> NSDiffableDataSourceSectionSnapshot<TaskVM> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<TaskVM>()
        func addItems(_ taskItems: [TaskVM], to parent: TaskVM?) {
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
    
}
