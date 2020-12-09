//
//  TaskDetailCommentViewController.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/01.
//

import UIKit

protocol TaskDetailCommentDisplayLogic: class {
    func displayFetchedComments(viewModel: TaskDetailModels.FetchComments.ViewModel)
}

class TaskDetailCommentViewController: UIViewController {
    
    // MARK: - Properties

    private var task: Task?
    private var interactor: TaskDetailBusinessLogic?
    private var dataSource: UICollectionViewDiffableDataSource<String, TaskDetailModels.CommentVM>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
    }
    
    // MARK: - Initialize
    
    func configure(interactor: TaskDetailBusinessLogic, task: Task) {
        self.interactor = interactor
        self.task = task
    }
    
// MARK: - Configure CollectionView Layout

private extension TaskDetailCommentViewController {
    
    func configureCollectionView() {
        commentCollectionView.collectionViewLayout = generateLayout()
        
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(44))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
        section.interGroupSpacing = 20
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

// MARK: - Configure CollectionView Data Source

private extension TaskDetailCommentViewController {
    
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<TaskCommentCell, TaskDetailModels.CommentVM> { (cell, _: IndexPath, taskItem) in
            cell.viewModel = taskItem
        }
        
        let imageCellRegistration = UICollectionView.CellRegistration<TaskCommentImageCell, TaskDetailModels.CommentVM> { (cell, _: IndexPath, taskItem) in
            cell.viewModel = taskItem
        }
        
        dataSource = UICollectionViewDiffableDataSource<String, TaskDetailModels.CommentVM>(collectionView: commentCollectionView, cellProvider: { (collectionView, indexPath, task) -> UICollectionViewCell? in
            
            if task.isImage {
                return collectionView.dequeueConfiguredReusableCell(using: imageCellRegistration, for: indexPath, item: task)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: task)
            }
            
        })
    }
    
    func snapshot(taskItems: [TaskDetailModels.CommentVM]) -> NSDiffableDataSourceSectionSnapshot<TaskDetailModels.CommentVM> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<TaskDetailModels.CommentVM>()
        snapshot.append(taskItems)
        
        return snapshot
    }
}

// MARK: - TaskDetailCommentViewController DisplayLogic

extension TaskDetailCommentViewController: TaskDetailCommentDisplayLogic {
    
    func displayFetchedComments(viewModel: TaskDetailModels.FetchComments.ViewModel) {
        let sectionSnapshot = snapshot(taskItems: viewModel.commentVMs)
        dataSource.apply(sectionSnapshot, to: "")
    }
}
