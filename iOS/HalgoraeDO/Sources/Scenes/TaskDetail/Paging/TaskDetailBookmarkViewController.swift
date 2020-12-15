//
//  TaskDetailBookmarkViewController.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/01.
//

import UIKit

protocol TaskDetailBookmarkDisplayLogic: class {
    func displayFetchedBookmarks(viewModel: TaskDetailModels.FetchBookmarks.ViewModel)
}

class TaskDetailBookmarkViewController: UIViewController {

    // MARK: - Properties

    private var task: Task?
    private var interactor: TaskDetailBusinessLogic?
    private var dataSource: UICollectionViewDiffableDataSource<String, TaskDetailModels.ContentsVM>!

    // MARK: - Views
    
    @IBOutlet weak var bookmarkCollectionView: UICollectionView!
    @IBOutlet weak var bookmarkAddView: CommentAddView! {
        didSet {
            bookmarkAddView.doneHandler = { [weak self] text in
                self?.createBookmark(text: text)
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
        interactor?.fetchBookmarks(request: .init(id: id))
    }
    
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
        
        self.bookmarkAddView.transform = CGAffineTransform(translationX: 0, y: -(keyboardFrame.height - (self.view.window?.safeAreaInsets.bottom ?? 0)))
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        self.bookmarkAddView.transform = .identity
    }
    
    func createBookmark(text: String) {
        guard let task = task else { return }
        //interactor?.createComment(request: .init(taskId: task.id, commentFields: .init(content: text)))
    }
}

// MARK: - Configure CollectionView Layout

private extension TaskDetailBookmarkViewController {
    
    func configureCollectionView() {
        bookmarkCollectionView.collectionViewLayout = generateLayout()
        
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
    
    func displayFetchedBookmarks(viewModel: TaskDetailModels.FetchBookmarks.ViewModel) {
        let sectionSnapshot = generateSnapshot(taskItems: viewModel.bookmarkVMs)
        dataSource.apply(sectionSnapshot, to: "")
    }
}
