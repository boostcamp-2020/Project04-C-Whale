//
//  TaskListViewController.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import UIKit

class TaskListViewController: UIViewController {
    
    typealias TaskVM = TaskListModels.DisplayedTask
    
    // MARK: - Properties
    
    /// 임시 property
    private var projectTitle = "할고래DO"
    private var interactor: TaskListBusinessLogic?
    private var router: (TaskListRoutingLogic & TaskListDataPassing)?
    private var dataSource: UICollectionViewDiffableDataSource<String, TaskVM>! = nil
    private(set) var selectedTasks = Set<TaskVM>() {
        didSet {
            guard isEditing else { return }
            title = "\(selectedTasks.count) 개 선택됨"
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLogic()
        configureCollectionView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.fetchTasks(request: .init(showCompleted: false))
    }
    
    // MARK: - Views
    
    @IBOutlet weak private var taskListCollectionView: UICollectionView!
    @IBOutlet weak private var moreButton: UIBarButtonItem!
    @IBOutlet weak private var addButton: RoundButton!
    @IBOutlet weak private var editToolBar: UIToolbar!
    
    // MARK: - Initialize
    
    private func configureLogic() {
        let presenter = TaskListPresenter(viewController: self)
        let interactor = TaskListInteractor(presenter: presenter,
                                            worker: TaskListWorker())
        
        self.interactor = interactor
    }
    
    // MARK: - Methods
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        set(editingMode: editing)
    }
    
    func set(editingMode: Bool) {
        if !editingMode {
            selectedTasks.removeAll()
        }
        title = editingMode ? "\(selectedTasks.count) 개 선택됨" : projectTitle
        taskListCollectionView.isEditing = editingMode
        moreButton.title = editingMode ? "취소" : "More"
        addButton.isHidden = editingMode
        editToolBar.isHidden = !editingMode
    }
    
    // MARK: IBActions
    
    @IBAction private func didTapMoreButton(_ sender: UIBarButtonItem) {
        
        guard !isEditing else {
            setEditing(false, animated: true)
            return
        }
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let showBoardAction = UIAlertAction(title: "보드로 보기", style: .default) { [weak self] (_: UIAlertAction) in
            guard let vc = self?.storyboard?.instantiateViewController(identifier: String(describing: TaskBoardViewController.self), creator: { coder -> TaskBoardViewController? in
                return TaskBoardViewController(coder: coder)
            }) else { return }
            
            let nav = self?.navigationController
            nav?.popViewController(animated: false)
            nav?.pushViewController(vc, animated: false)
        }

        let addSectionAction = UIAlertAction(title: "섹션 추가", style: .default) { (_: UIAlertAction) in
            
        }

        let selectTaskAction = UIAlertAction(title: "작업 선택", style: .default) { [weak self] (_: UIAlertAction) in
            
            self?.setEditing(true, animated: true)
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (_: UIAlertAction) in
            
        }

        [showBoardAction, addSectionAction, selectTaskAction, cancelAction].forEach { alert.addAction($0) }
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func didTapAddButton(_ sender: RoundButton) {
        
    }
}

// MARK: - TaskList Display Logic

extension TaskListViewController: TaskListDisplayLogic {
    
    func displayFetchTasks(viewModel: TaskListModels.FetchTasks.ViewModel) {
        let snapShot = snapshot(taskItems: viewModel.displayedTasks)
        dataSource.apply(snapShot, to: projectTitle, animatingDifferences: true)
    }
    
    func displayDetail(of task: Task) {
        
    }
    
    func displayFinishChanged(viewModel: TaskListModels.FinishTask.ViewModel) {
        var currentSnapshot = self.dataSource.snapshot()
        if !viewModel.showCompleted {
            let completedTasks = viewModel.displayedTasks.filter { $0.isCompleted }
            currentSnapshot.deleteItems(completedTasks)
            dataSource.apply(currentSnapshot)
        }
        
        
    }
}

// MARK: - Configure CollectionView Layout

private extension TaskListViewController {
    func configureCollectionView() {
        taskListCollectionView.collectionViewLayout = generateLayout()
        taskListCollectionView.allowsMultipleSelectionDuringEditing = true
        taskListCollectionView.delegate = self
    }
    
    func generateLayout() -> UICollectionViewLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        listConfiguration.leadingSwipeActionsConfigurationProvider = { indexPath in
            let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, view, completion) in
                guard let self = self else { return }
                if !self.isEditing {
                    self.setEditing(true, animated: true)
                }
                
                let taskVM = self.dataSource.snapshot().itemIdentifiers[indexPath.item]
                self.selectedTasks.insert(taskVM)
                self.taskListCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init())
            }
            return UISwipeActionsConfiguration(actions: [editAction])
        }
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        return layout
    }
}

// MARK: - Configure CollectionView Data Source

private extension TaskListViewController {

    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TaskCollectionViewListCell, TaskVM> { [weak self] (cell, _: IndexPath, taskItem) in
            
            cell.taskViewModel = taskItem
            cell.finishHandler = { [weak self] task in
                guard let self = self,
                      let task = task
                else {
                    return
                }
                
                self.interactor?.changeFinish(request: .init(displayedTasks: [task]))
            }
            
            let disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .automatic)
            
            cell.accessories = taskItem.subItems.isEmpty ? [] : [.outlineDisclosure(options: disclosureOptions)]
        }
        
        self.dataSource = UICollectionViewDiffableDataSource<String, TaskVM>(collectionView: taskListCollectionView, cellProvider: { (collectionView, indexPath, task) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: task)
        })
    }
    
    func snapshot(taskItems: [TaskVM]) -> NSDiffableDataSourceSectionSnapshot<TaskVM> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<TaskVM>()

        func addItems(_ taskItems: [TaskVM], to parent: TaskVM?) {
            snapshot.append(taskItems, to: parent)
            for taskItem in taskItems where !taskItem.subItems.isEmpty {
                addItems(taskItem.subItems, to: taskItem)
            }
        }

        addItems(taskItems, to: nil)
        return snapshot
    }
}

// MARK:  - UICollectionView Delegate

extension TaskListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let taskVM = dataSource.snapshot().itemIdentifiers[indexPath.item]
        guard !isEditing else {
            selectedTasks.insert(taskVM)
            return
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
        // TODO: request show detail task
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let taskVM = dataSource.snapshot().itemIdentifiers[indexPath.item]
        guard !isEditing else {
            selectedTasks.remove(taskVM)
            return
        }
    }
}
