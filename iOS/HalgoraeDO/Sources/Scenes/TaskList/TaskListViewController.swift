//
//  TaskListViewController.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import UIKit

class TaskListViewController: UIViewController {
    
    // MARK:  - Constants
    
    typealias TaskVM = TaskListModels.DisplayedTask
    
    // MARK: - Properties
    
    /// 임시 property
    var projectTitle = "할고래DO"
    private var interactor: TaskListBusinessLogic?
    private var router: (TaskListRoutingLogic & TaskListDataPassing)?
    private var dataSource: UICollectionViewDiffableDataSource<String, TaskVM>! = nil
    private var displayCompleted = false
    private var presentConfirmActionWorkItem: DispatchWorkItem?
    private var childCheck = 0
    private var displayTasks: [TaskListModels.DisplayedTask] = Array()
    private(set) var selectedTasks = Set<TaskVM>() {
        didSet {
            guard isEditing else { return }
            title = "\(selectedTasks.count) 개 선택됨"
        }
    }
    
    // MARK: Views
    
    @IBOutlet weak private var taskListCollectionView: UICollectionView!
    @IBOutlet weak private var moreButton: UIBarButtonItem!
    @IBOutlet weak private var editToolBar: UIToolbar!
    @IBOutlet weak private var confirmActionView: ConfirmActionView!
    private var lineView: UIView = UIView()
    private var startIndex: IndexPath?
    private var startPoint: CGPoint?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = projectTitle
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
        router = TaskListRouter(viewController: self, dataStore: interactor)
    }
    
    // MARK: - Methods
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        set(editingMode: editing)
    }
    
    private func set(editingMode: Bool) {
        if !editingMode {
            selectedTasks.removeAll()
        }
        title = editingMode ? "\(selectedTasks.count) 개 선택됨" : projectTitle
        taskListCollectionView.isEditing = editingMode
        moreButton.title = editingMode ? "취소" : "More"
        editToolBar.isHidden = !editingMode
    }
    
    private func slideRightConfirmActionViewWillDismiss(targetView: UIView,
                                                withDuration duration: TimeInterval = 0.5,
                                                delay: TimeInterval = 0,
                                                usingSpringWithDamping dampingRatio: CGFloat = 0.7,
                                                initialSpringVelocity velocity: CGFloat = 0.5,
                                                options: UIView.AnimationOptions = [.curveEaseIn],
                                                dismiss deadline: DispatchTime = .now() + 3) {
        targetView.transform = .init(translationX: -targetView.frame.maxX, y: 0)
        targetView.isHidden = false
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity, options: options) {
            targetView.transform = .identity
        }
        
        self.presentConfirmActionWorkItem?.cancel()
        self.presentConfirmActionWorkItem = DispatchWorkItem { targetView.isHidden = true }
        if let workItem = self.presentConfirmActionWorkItem {
            DispatchQueue.main.asyncAfter(deadline: deadline, execute: workItem)
        }
    }
    
    // MARK: IBActions
    
    @IBAction private func didTapMoreButton(_ sender: UIBarButtonItem) {
        guard !isEditing else {
            setEditing(false, animated: true)
            return
        }
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let showBoardAction = UIAlertAction(title: "보드로 보기", style: .default) { (_: UIAlertAction) in
            guard let vc = self.storyboard?.instantiateViewController(identifier: String(describing: TaskBoardViewController.self), creator: { coder -> TaskBoardViewController? in
                return TaskBoardViewController(coder: coder)
            }) else {
                return
            }
            
            vc.title = self.projectTitle
            let nav = self.navigationController
            nav?.popViewController(animated: false)
            nav?.pushViewController(vc, animated: false)
        }

        let addSectionAction = UIAlertAction(title: "섹션 추가", style: .default) { (_: UIAlertAction) in
            
        }

        let selectTaskAction = UIAlertAction(title: "작업 선택", style: .default) { (_: UIAlertAction) in
            self.setEditing(true, animated: true)
        }
        
        let changeCompletedDisplayTitle = displayCompleted ? "완료된 항목 숨기기" : "완료된 항목 보기"
        let changeCompletedDisplayAction = UIAlertAction(title: changeCompletedDisplayTitle, style: .default) { (_: UIAlertAction) in
            self.displayCompleted.toggle()
            self.interactor?.fetchTasks(request: .init())
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (_: UIAlertAction) in
            
        }
        
        [
            showBoardAction,
            addSectionAction,
            selectTaskAction,
            changeCompletedDisplayAction,
            cancelAction
        ].forEach {
            alert.addAction($0)
        }
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func didTapAddButton(_ sender: RoundButton) {
        
    }
}

// MARK: - Configure CollectionView Layout

private extension TaskListViewController {
    
    func configureCollectionView() {
        taskListCollectionView.collectionViewLayout = generateLayout()
        taskListCollectionView.allowsMultipleSelectionDuringEditing = true
        taskListCollectionView.delegate = self
        taskListCollectionView.dragDelegate = self
        taskListCollectionView.dropDelegate = self
        taskListCollectionView.dragInteractionEnabled = true
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
        let cellRegistration = UICollectionView.CellRegistration<TaskCollectionViewListCell, TaskVM> { (cell, _: IndexPath, taskItem) in
            cell.taskViewModel = taskItem
            cell.finishHandler = { [weak self] task in
                guard let self = self else { return }
                self.slideRightConfirmActionViewWillDismiss(targetView: self.confirmActionView)
                self.confirmActionView.backHandler = { [weak self] in
                    var cancelTask = task
                    cancelTask.isCompleted.toggle()
                    cell.taskViewModel = cancelTask
                    self?.interactor?.changeFinish(request: .init(displayedTasks: [cancelTask]))
                    self?.confirmActionView.isHidden = true
                }
                
                self.interactor?.changeFinish(request: .init(displayedTasks: [task]))
                
            }
            let disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .automatic)
            cell.accessories = taskItem.subItems.isEmpty ? [] : [.outlineDisclosure(options: disclosureOptions)]
        }
        
        dataSource = UICollectionViewDiffableDataSource<String, TaskVM>(collectionView: taskListCollectionView, cellProvider: { (collectionView, indexPath, task) -> UICollectionViewCell? in
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


// MARK: - TaskList Display Logic

extension TaskListViewController: TaskListDisplayLogic {
    
    func displayFetchTasks(viewModel: TaskListModels.FetchTasks.ViewModel) {
        let currentSnapshot = dataSource.snapshot(for: projectTitle)
        displayTasks = filterCompletedIfNeeded(for: viewModel.displayedTasks)
        var snapShot = snapshot(taskItems: displayTasks)
        for item in snapShot.items {
            guard currentSnapshot.contains(item),
                currentSnapshot.isExpanded(item)
            else {
                continue
            }
            
            snapShot.expand([item])
        }
        dataSource.apply(snapShot, to: projectTitle, animatingDifferences: true)
    }
    
    func displayDetail(of task: Task) {
        
    }
    
    func displayFinishChanged(viewModel: TaskListModels.FinishTask.ViewModel) {
        var currentSnapshot = dataSource.snapshot()
        
        if !displayCompleted {
            let completedTasks = viewModel.displayedTasks.filter { $0.isCompleted }
            currentSnapshot.deleteItems(completedTasks)
            dataSource.apply(currentSnapshot)
        }
    }
    
    // MARK: Helper Functions
    
    func filterCompletedIfNeeded(for displayedTasks: [TaskListModels.DisplayedTask]) -> [TaskListModels.DisplayedTask] {
        guard !displayCompleted else { return displayedTasks }
        
        var filteredTasks = [TaskListModels.DisplayedTask]()
        for task in displayedTasks {
            guard !task.isCompleted else { continue }
            var task = task
            task.subItems = task.subItems.filter { !$0.isCompleted }
            filteredTasks.append(task)
        }

        return filteredTasks
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
        router?.routeToTaskDetail(for: taskVM)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let taskVM = dataSource.snapshot().itemIdentifiers[indexPath.item]
        guard !isEditing else {
            selectedTasks.remove(taskVM)
            return
        }
    }
}

// MARK: - UICollectionViewDragDelegate

extension TaskListViewController: UICollectionViewDragDelegate {
    
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
        guard let taskObject = taskListCollectionView.cellForItem(at: indexPath) as? TaskCollectionViewListCell else { return [] }
        let provider = NSItemProvider(object: taskObject.taskViewModel!.id.uuidString as NSString)
        let dragItem = UIDragItem(itemProvider: provider)
        guard let collectionView = taskListCollectionView else { return [dragItem] }
        let cell = collectionView.cellForItem(at: indexPath)
        dragItem.localObject = cell
        
        return [dragItem]
    }
}

// MARK: - UICollectionViewDropDelegate

extension TaskListViewController: UICollectionViewDropDelegate {
    
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
        
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        lineView.removeFromSuperview()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        performDropWith coordinator: UICollectionViewDropCoordinator
    ) {
        lineView.removeFromSuperview()
        
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {//자신으로부터 나왔을 때
                if (item.dragItem.localObject as? TaskCollectionViewListCell) != nil {
                    var tempIndex: IndexPath
                    if destinationIndexPath.section == sourceIndexPath.section && destinationIndexPath.row > sourceIndexPath.row {
                        tempIndex = IndexPath(row: destinationIndexPath.row, section: destinationIndexPath.section)
                    } else {
                        tempIndex = IndexPath(row: destinationIndexPath.row - 1, section: destinationIndexPath.section)
                    }
            
                    let snapShot = dropHelper(displayTasks, dataSource.itemIdentifier(for: sourceIndexPath)!, dataSource.itemIdentifier(for: tempIndex)!)
                    dataSource.apply(snapShot, to: projectTitle, animatingDifferences: true)
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                }
            }
        }
    }
    
    private func dropHelper(_ taskItems1: [TaskVM], _ source: TaskVM, _ destination: TaskVM) -> NSDiffableDataSourceSectionSnapshot<TaskVM> {
        func configNewItems(_ taskItems: [TaskVM], _ source: TaskVM, _ destination: TaskVM) -> [TaskVM] {
            var tempItems: [TaskVM] = []
            for i in 0..<taskItems.count {
                let tempSubitems =  taskItems[i].subItems.filter {
                    $0.id != source.id
                }
                var tempItem = taskItems[i]
                tempItem.subItems = tempSubitems
                if taskItems[i].id != source.id {
                    tempItems.append(tempItem)
                }
            }
            
            return tempItems
        }
        
        func findItem(_ taskItems: [TaskVM], _ source: TaskVM, _ destination: TaskVM) -> [TaskVM] {
            var tempItems: [TaskVM] = []
            for i in 0..<taskItems.count {
                tempItems.append(taskItems[i])
                if !taskItems[i].subItems.isEmpty {
                    tempItems[i].subItems = findItem(taskItems[i].subItems, source, destination)
                }
                if taskItems[i].id == destination.id {
                    var tempItem = taskItems
                    tempItem.insert(source, at: i + 1)
                    return tempItem
                }
            }
            
            return tempItems
        }
        
        var configAfterFilter = configNewItems(taskItems1, source, destination)//source 제외한 items
        func findItemForParents(_ taskItems: [TaskVM], _ source: TaskVM, _ destination: TaskVM) {
            for i in 0..<taskItems.count {
                if taskItems[i].id == destination.id {
                    configAfterFilter[i].subItems.insert(source, at: 0)
                }
            }
        }
        
        var newItemAfterConfig: [TaskVM] = []
        if destination.parentPosition == nil && childCheck == 1 { //부모 작업의 바로 아래에 append
            findItemForParents(configAfterFilter, source, destination)
            newItemAfterConfig = configAfterFilter
        } else { //child check필요 없이 그냥 넣기
            newItemAfterConfig = findItem(configAfterFilter, source, destination)
        }
        displayTasks = newItemAfterConfig //원본 교체
        let snapShot = snapshot(taskItems: newItemAfterConfig)

        return snapShot
    }
}


private extension TaskListViewController {
    
    func setLocation(_ location: CGPoint, _ destination: IndexPath?) {
        lineView.removeFromSuperview()
        guard let destination = destination,
              let startIndex = startIndex,
              let startPoint = startPoint,
              let collectionView = taskListCollectionView,
              destination.row != 0
        else {
            return
        }
        
        /*
         나보다 아래인지 위인지에 따라 destination index를 다르게 설정
         */
        var tempIndex: IndexPath
        if destination.section == startIndex.section && destination.row > startIndex.row {
            tempIndex = IndexPath(row: destination.row, section: destination.section)
        } else {
            tempIndex = IndexPath(row: destination.row - 1, section: destination.section)
        }
        
        /*
         터치 위치에 따라 같은level 혹은 한단계 하위 level에 line 표시
         */
        if startPoint.x <= location.x - 50 {
            childCheck = 1
        } else {
            childCheck = 0
        }
        if let cell = collectionView.cellForItem(at: tempIndex) as? UICollectionViewListCell {
            if cell.indentationLevel == 1 { childCheck = 0 }
            print(childCheck)
            let depthWidth: CGFloat = CGFloat(cell.indentationLevel * 20 + childCheck * 20)
            lineView = UIView(frame: CGRect(x: 10 + depthWidth, y: cell.frame.height - 2, width: cell.frame.width - depthWidth - 20, height: 5))
            lineView.backgroundColor = .halgoraedoMint
            lineView.layer.cornerRadius = 2;
            lineView.layer.masksToBounds = true;
            cell.addSubview(lineView)
        }
    }
}

