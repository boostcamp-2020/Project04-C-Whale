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
    private var dataSource: UICollectionViewDiffableDataSource<String, TaskDetailModels.ContentsVM>!
    
    // MARK: - Views
    
    @IBOutlet weak var commentCollectionView: UICollectionView!
    @IBOutlet weak var commentAddView: CommentAddView! {
        didSet {
            commentAddView.doneHandler = { [weak self] text in
                self?.createComment(text: text)
            }
        }
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        addObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let id = task?.id else { return }
        interactor?.fetchComments(request: .init(id: id))
    }
    
    // MARK: - Initialize
    
    func configure(interactor: TaskDetailBusinessLogic, task: Task) {
        self.interactor = interactor
        self.task = task
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        self.commentAddView.transform = CGAffineTransform(translationX: 0, y: -(keyboardFrame.height - (self.view.window?.safeAreaInsets.bottom ?? 0)))
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        self.commentAddView.transform = .identity
    }
    
    func createComment(text: String) {
        guard let task = task else { return }
        interactor?.createComment(request: .init(taskId: task.id, commentFields: .init(content: text)))
    }
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
        section.contentInsets = .init(top: 8, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = 8
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

// MARK: - Configure CollectionView Data Source

private extension TaskDetailCommentViewController {
    
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<TaskDetailContentsCellCollectionViewCell, TaskDetailModels.ContentsVM> { (cell, _: IndexPath, taskItem) in
            cell.viewModel = taskItem
        }
        
        dataSource = UICollectionViewDiffableDataSource<String, TaskDetailModels.ContentsVM>(collectionView: commentCollectionView, cellProvider: { (collectionView, indexPath, task) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: task)
        })
    }
    
    func generateSnapshot(taskItems: [TaskDetailModels.ContentsVM]) -> NSDiffableDataSourceSectionSnapshot<TaskDetailModels.ContentsVM> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<TaskDetailModels.ContentsVM>()
        snapshot.append(taskItems)
        
        return snapshot
    }
}

// MARK: - TaskDetailCommentViewController DisplayLogic

extension TaskDetailCommentViewController: TaskDetailCommentDisplayLogic {
    
    func displayFetchedComments(viewModel: TaskDetailModels.FetchComments.ViewModel) {
        let sectionSnapshot = generateSnapshot(taskItems: viewModel.commentVMs)
        dataSource.apply(sectionSnapshot, to: "")
    }
}
