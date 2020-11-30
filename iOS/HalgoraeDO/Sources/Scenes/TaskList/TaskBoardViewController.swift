//
//  TaskBoardViewController.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import UIKit

class TaskBoardViewController: UIViewController {
    
    typealias TaskVM = TaskListModels.DisplayedTask
    
    // MARK: - Properties
    
    private var interactor: TaskListBusinessLogic?
    private var router: (TaskListRoutingLogic & TaskListDataPassing)?
    private var dataSource: UICollectionViewDiffableDataSource<String, TaskVM>! = nil
    private var lineView: UIView = UIView()
    private var startIndex: IndexPath?
    private var startPoint: CGPoint?
    private let visualEffectView = UIVisualEffectView()
    private var taskAddViewController: TaskAddViewController = TaskAddViewController()
    
    // MARK: - Views
    
    @IBOutlet weak private var taskBoardCollectionView: UICollectionView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLogic()
        configureCollectionView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.fetchTasks(request: .init())
    }
    
    // MARK: - Initialize
    
    private func configureLogic() {
        let presenter = TaskListPresenter(viewController: self)
        let interactor = TaskListInteractor(presenter: presenter, worker: TaskListWorker())
        self.interactor = interactor
    }
    
    func showAddTaskView() {
        visualEffectView.frame = self.view.frame
        self.view.addSubview(visualEffectView)
        taskAddViewController = TaskAddViewController()
        self.addChild(taskAddViewController)
        self.view.addSubview(taskAddViewController.view)
        taskAddViewController.view.backgroundColor = .white
        taskAddViewController.view.frame = CGRect(x: 0, y: self.view.bounds.height - 130, width: self.view.bounds.width, height: 130)
        visualEffectView.backgroundColor = .gray
        visualEffectView.alpha = 0.4
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleViewTap(recognizer:))))
    }
    
    @objc
    func handleViewTap (recognizer: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let selectTaskAction = UIAlertAction(title: "삭제", style: .destructive) { (action) in
            self.taskAddViewController.view.removeFromSuperview()
            self.visualEffectView.removeFromSuperview()
        }
        let cancelAction = UIAlertAction(title: "계속 편집", style: .default) { (action) in
        }
        [selectTaskAction, cancelAction].forEach { alert.addAction($0) }
        present(alert, animated: true, completion: nil)
    }
    
    // MARK:  IBActions
    @IBAction func didTapMoreButton(_ sender: UIBarButtonItem) {
        
        guard !isEditing else {
            setEditing(false, animated: true)
            return
        }
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let showBoardAction = UIAlertAction(title: "목록으로 보기", style: .default) { [weak self] (_: UIAlertAction) in
            guard let vc = self?.storyboard?.instantiateViewController(identifier: String(describing: TaskListViewController.self), creator: { coder -> TaskListViewController? in
                return TaskListViewController(coder: coder)
            }) else { return }
            
            let nav = self?.navigationController
            nav?.popViewController(animated: false)
            nav?.pushViewController(vc, animated: false)
        }
        
        let addSectionAction = UIAlertAction(title: "섹션 추가", style: .default) { (_: UIAlertAction) in
            
        }
        
        let addTaskAction = UIAlertAction(title: "작업 추가", style: .default) { [weak self] (_: UIAlertAction) in
            self?.showAddTaskView()
        }
        
        let selectTaskAction = UIAlertAction(title: "작업 선택", style: .default) { [weak self] (_: UIAlertAction) in
            self?.setEditing(true, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (_: UIAlertAction) in
            
        }
        
        [showBoardAction, addSectionAction, addTaskAction, selectTaskAction, cancelAction].forEach { alert.addAction($0) }
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - TaskList Display Logic

extension TaskBoardViewController: TaskListDisplayLogic {
    func displayFinishChanged(viewModel: TaskListModels.FinishTask.ViewModel) {
        
    }
    
    func displayFetchTasks(viewModel: TaskListModels.FetchTasks.ViewModel) {
        let snapShot = snapshot(taskItems: viewModel.displayedTasks)
        dataSource.apply(snapShot, animatingDifferences: false)
    }
    
    func displayDetail(of task: Task) {
        
    }
}

// MARK: - Configure CollectionView Layout

private extension TaskBoardViewController {
    
    private func configureCollectionView() {
        taskBoardCollectionView.dragDelegate = self
        taskBoardCollectionView.dropDelegate = self
        taskBoardCollectionView.dragInteractionEnabled = true
        taskBoardCollectionView.collectionViewLayout = generateLayout()
        taskBoardCollectionView.isPagingEnabled = true
    }
    
    private func generateLayout() -> UICollectionViewLayout {
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        config.scrollDirection = .horizontal
        
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let section: NSCollectionLayoutSection
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(100))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 15
            section.orthogonalScrollingBehavior = .paging
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return section
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        
    }
}

// MARK: - Configure CollectionView Data Source

private extension TaskBoardViewController {
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TaskCollectionViewListCell, TaskVM> { [weak self] (cell, indexPath, taskItem) in
            
            cell.taskViewModel = taskItem
            cell.finishHandler = { [weak self] task in
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
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.cornerRadius = 8
            background.strokeColor = .systemGray3
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 5)
            cell.layer.shadowRadius = 7.0
            cell.layer.shadowOpacity = 0.2
            cell.layer.masksToBounds = false
            cell.backgroundConfiguration = background
        }
        
        self.dataSource = UICollectionViewDiffableDataSource<String, TaskVM>(collectionView: taskBoardCollectionView, cellProvider: { (collectionview, indexPath, task) -> UICollectionViewCell? in
            return collectionview.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: task)
        })
        
    }
    
    private func snapshot(taskItems: [TaskVM]) -> NSDiffableDataSourceSnapshot<String, TaskVM> {
        
        var snapshot = NSDiffableDataSourceSnapshot<String, TaskVM>()
        for i in 0..<2 {
            snapshot.appendSections(["\(i)"])
            // TODO: 뷰 테스트를 위한 Task배열을 바로 만들어 넣어주는데 이 배열을 taskItems로 변경하기
//            snapshot.appendItems([TaskVM(section: "123", title: "123", isCompleted: false, depth: 0, parent: nil, subTasks: []),TaskVM(section: "123", title: "123", isCompleted: false, depth: 0, parent: nil, subTasks: []),TaskVM(section: "123", title: "123", isCompleted: false, depth: 0, parent: nil, subTasks: []),TaskVM(section: "123", title: "123", isCompleted: false, depth: 0, parent: nil, subTasks: []),TaskVM(section: "123", title: "123", isCompleted: false, depth: 0, parent: nil, subTasks: [])], toSection: "\(i)")
        }
        
        return snapshot
        
    }
}

// MARK: - UICollectionViewDragDelegate
extension TaskBoardViewController: UICollectionViewDragDelegate {
    
    /* Drag가 시작되었을 때 start point 기록*/
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        startPoint = session.location(in: collectionView)
        collectionView.performUsingPresentationValues {
            startIndex = collectionView.indexPathForItem(at: session.location(in: collectionView))
        }
        return dragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionIsRestrictedToDraggingApplication session: UIDragSession) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        let cell = taskBoardCollectionView.cellForItem(at: indexPath)
        let taskObject = NSString(string: "_")
        let provider = NSItemProvider(object: taskObject)
        let dragItem = UIDragItem(itemProvider: provider)
        dragItem.localObject = cell
        return [dragItem]
    }
}

// MARK: - UICollectionViewDropDelegate
extension TaskBoardViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSAttributedString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let location = session.location(in: collectionView)
        var correctDestination: IndexPath?
        collectionView.performUsingPresentationValues {
            correctDestination = collectionView.indexPathForItem(at: location)
        }
        guard let destination = correctDestination else {
            return UICollectionViewDropProposal(
                operation: .cancel, intent: .unspecified
            )
        }
        setLocation(session.location(in: collectionView), destination)
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        lineView.removeFromSuperview()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        performDropWith coordinator: UICollectionViewDropCoordinator
    ) {
        lineView.removeFromSuperview()
        print("destination path:", coordinator.destinationIndexPath)
    }
    
}

private extension TaskBoardViewController {
    func setLocation(_ location: CGPoint, _ destination: IndexPath?) {
        lineView.removeFromSuperview()
        guard let destination = destination, let startIndex = startIndex, let startPoint = startPoint  else{
            return
        }
        if destination.row == 0 {
            return
        }
        print("location:", location)
        print("start:", startPoint)
        
        /*
         나보다 아래인지 위인지에 따라 destination index를 다르게 설정
         */
        var tempIndex: IndexPath
        if destination.section == startIndex.section && destination.row > startIndex.row {
            tempIndex = IndexPath(row: destination.row, section: destination.section)
        }else {
            tempIndex = IndexPath(row: destination.row - 1, section: destination.section)
        }
        /*
         터치 위치에 따라 같은level 혹은 한단계 하위 level에 line 표시
         */
        
        if let cell = self.taskBoardCollectionView.cellForItem(at: tempIndex) as? UICollectionViewListCell {
            lineView = UIView(frame: CGRect(x: 10, y: cell.frame.height - 2, width: cell.frame.width - 20, height: 5))
            lineView.backgroundColor = .blue
            lineView.layer.cornerRadius = 5;
            lineView.layer.masksToBounds = true;
            cell.addSubview(lineView)
        }
    }
}



