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
    private var dataSource: UICollectionViewDiffableDataSource<String, Task>! = nil
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLogic()
        configureCollectionView()
        configureDataSource()
    }
    
    // MARK: Initialize
    // MARK: - Views
    
    @IBOutlet weak private var taskListCollectionView: UICollectionView!
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
// MARK: - Configure CollectionView Layout
    
private extension TaskListViewController {
    private func configureCollectionView() {
        taskListCollectionView.collectionViewLayout = generateLayout()
}
    
    private func generateLayout() -> UICollectionViewLayout {
        let listConfiguration = UICollectionLayoutListConfiguration(appearance: .sidebar)
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        return layout
    }
}

// MARK: - Configure CollectionView Data Source

private extension TaskListViewController {

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TaskCollectionViewListCell, Task> { (cell, indexPath, taskItem) in

            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = taskItem.title
            let disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = taskItem.subTasks.isEmpty ? [] : [.outlineDisclosure(options: disclosureOptions)]
            cell.contentConfiguration = contentConfiguration
            cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
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
