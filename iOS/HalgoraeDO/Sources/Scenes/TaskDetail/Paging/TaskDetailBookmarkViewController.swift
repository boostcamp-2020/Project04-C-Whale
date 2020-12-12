//
//  TaskDetailBookmarkViewController.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/01.
//

import UIKit

protocol TaskDetailBookmarkDisplayLogic: class {
    
}

class TaskDetailBookmarkViewController: UIViewController {

    private var task: Task?
    private var interactor: TaskDetailBusinessLogic?
    private var dataSource: UICollectionViewDiffableDataSource<String, TaskDetailModels.ContentsVM>!

    // MARK: - Views
    
    @IBOutlet weak var bookmarkCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
    }

    func configure(interactor: TaskDetailBusinessLogic, task: Task) {
        self.interactor = interactor
        self.task = task
    }
}

// MARK: - Configure CollectionView Data Source

private extension TaskDetailBookmarkViewController {

    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TaskDetailContentsCellCollectionViewCell, TaskDetailModels.ContentsVM> { (cell, _: IndexPath, taskItem) in
            cell.viewModel = taskItem
        }

        dataSource = UICollectionViewDiffableDataSource<String, TaskDetailModels.ContentsVM>(collectionView: bookmarkCollectionView, cellProvider: { (collectionView, indexPath, task) -> UICollectionViewCell? in

            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: task)
        })
    }

    func generateSnapshot(taskItems: [TaskDetailModels.ContentsVM]) -> NSDiffableDataSourceSectionSnapshot<TaskDetailModels.ContentsVM> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<TaskDetailModels.ContentsVM>()
        snapshot.append(taskItems)

        return snapshot
    }
}

// MARK: - TaskDetailBookmark DisplayLogic

extension TaskDetailBookmarkViewController: TaskDetailBookmarkDisplayLogic {

}
