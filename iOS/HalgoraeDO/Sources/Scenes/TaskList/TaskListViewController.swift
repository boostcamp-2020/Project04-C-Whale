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
    private let project: Project
    private var interactor: TaskListBusinessLogic?
    private var router: (TaskListRoutingLogic & TaskListDataPassing)?
    private var dataSource: UICollectionViewDiffableDataSource<TaskListModels.SectionVM, TaskVM>! = nil
    private var displayCompleted = false
    private var presentConfirmActionWorkItem: DispatchWorkItem?
    private var childCheck = 0
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
    
    init?(coder: NSCoder, project: Project) {
        self.project = project
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        self.project = Project(title: "")
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = project.title
        configureLogic()
        configureCollectionView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.fetchTasks(request: .init(projectId: project.id ?? ""))
    }
    
    // MARK: - Initialize
    
    private func configureLogic() {
        let presenter = TaskListPresenter(viewController: self)
        let interactor = TaskListInteractor(presenter: presenter, worker: TaskListWorker(sessionManager: SessionManager(configuration: .default)))
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
        title = editingMode ? "\(selectedTasks.count) 개 선택됨" : project.title
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
            
            vc.title = self.project.title
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
            self.interactor?.fetchTasks(request: .init(projectId: self.project.id))
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
    
    @IBAction func didTapAddButton(_ sender: UIButton) {
        let taskAddViewController = TaskAddViewController()
        taskAddViewController.modalPresentationStyle = .overCurrentContext
        taskAddViewController.delegate = self
        present(taskAddViewController, animated: true, completion: nil)
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
        listConfiguration.headerMode = .supplementary
        
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
        
        dataSource = UICollectionViewDiffableDataSource<TaskListModels.SectionVM, TaskVM>(collectionView: taskListCollectionView, cellProvider: { (collectionView, indexPath, task) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: task)
        })
        configureDataSourceForHeader(dataSource)
    }
    
    func configureDataSourceForHeader(_ dataSource: UICollectionViewDiffableDataSource<TaskListModels.SectionVM, TaskListModels.DisplayedTask>) {
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <TaskBoardSupplementaryView>(elementKind: "Header") {
            (supplementaryView, string, indexPath) in
            supplementaryView.configureHeader(sectionName: dataSource.snapshot().sectionIdentifiers[indexPath.section].title, rowNum: dataSource.snapshot().sectionIdentifiers[indexPath.section].tasks.count)
        }
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.taskListCollectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
    }
    
    func generateSnapshot(taskItems: [TaskVM]) -> NSDiffableDataSourceSectionSnapshot<TaskVM> {
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
        var snapshot = NSDiffableDataSourceSnapshot<TaskListModels.SectionVM, TaskListModels.DisplayedTask>()
        snapshot.appendSections(viewModel.sectionVMs)
        dataSource.apply(snapshot, animatingDifferences: false)
        for sectionVM in viewModel.sectionVMs {
            let sectionSnapshot = generateSnapshot(taskItems: sectionVM.tasks)
            dataSource.apply(sectionSnapshot, to: sectionVM)
        }
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
        
        if let cell = collectionView.cellForItem(at: indexPath) as? TaskCollectionViewListCell{
            let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
            var currentSnapshot = dataSource.snapshot(for: section)
            
            for item in currentSnapshot.items {
                if item.id == cell.taskViewModel?.id {
                    currentSnapshot.collapse([item])
                }
            }
            dataSource.apply(currentSnapshot, to: section, animatingDifferences: true)
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
        let provider = NSItemProvider(object: taskObject.taskViewModel!.id as NSString)
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
        
        return UICollectionViewDropProposal(operation: setLocation(session.location(in: collectionView), destination) ? .move : .forbidden, intent: .insertAtDestinationIndexPath)
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
            guard let sourceIndexPath = item.sourceIndexPath else { return }
       
            if (item.dragItem.localObject as? TaskCollectionViewListCell) != nil {
                var tempIndex: IndexPath
                if destinationIndexPath.section == sourceIndexPath.section && destinationIndexPath.row > sourceIndexPath.row {
                    tempIndex = IndexPath(row: destinationIndexPath.row, section: destinationIndexPath.section)
                } else {
                    tempIndex = IndexPath(row: destinationIndexPath.row - 1, section: destinationIndexPath.section)
                }
                
                dropHelper(sourceIndexPath: sourceIndexPath, destinationIndexPath: tempIndex)
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            }
        }
    }
    
    // MARK: Helper Functions
    
    private func removeTaskFromTasks(_ taskItems: [TaskVM], _ sourceId: String) -> [TaskVM] {
        var tempItems: [TaskVM] = []
        for i in 0..<taskItems.count {
            let tempSubitems =  taskItems[i].subItems.filter {
                $0.id != sourceId
            }
            
            var tempItem = taskItems[i]
            tempItem.subItems = tempSubitems
            if taskItems[i].id != sourceId {
                tempItems.append(tempItem)
            }
        }
        return tempItems
    }
    
    private func addTaskAtTasks(_ taskItems: [TaskVM], _ source: TaskVM, _ destinationId: String) -> [TaskVM] {
        var tempItems: [TaskVM] = []
        for i in 0..<taskItems.count {
            tempItems.append(taskItems[i])
            if !taskItems[i].subItems.isEmpty {
                tempItems[i].subItems = addTaskAtTasks(taskItems[i].subItems, source, destinationId)
            }
            if taskItems[i].id == destinationId {
                var tempItem = taskItems
                tempItem.insert(source, at: i + 1)
                return tempItem
            }
        }
        
        return tempItems
    }
    
    private func addTaskAtFirstOfSubitems(_ taskItems: [TaskVM], _ source: TaskVM, _ destinationId: String) -> [TaskVM] {
        var tempItems: [TaskVM] = taskItems
        for i in 0..<tempItems.count {
            if tempItems[i].id == destinationId {
                tempItems[i].subItems.insert(source, at: 0)
            }
        }
        
        return tempItems
    }
    
    private func dropHelper(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
        guard let sourceTask = dataSource.itemIdentifier(for: sourceIndexPath)
        else {
            return
        }
        let sourceSection = dataSource.snapshot().sectionIdentifiers[sourceIndexPath.section]
        let destinationSection = dataSource.snapshot().sectionIdentifiers[destinationIndexPath.section]
        
        guard let destinationTask = dataSource.itemIdentifier(for: destinationIndexPath)
        else {//맨 위에 추가할 때 DESTINATIONTASK가 NIL이다.
            let tasksAfterRemove = removeTaskFromTasks(dataSource.snapshot(for: sourceSection).rootItems, sourceTask.id)
            let sourceSnapShot = generateSnapshot(taskItems: tasksAfterRemove)
            dataSource.apply(sourceSnapShot, to: sourceSection)
            
            var items = dataSource.snapshot(for: destinationSection).rootItems
            items.insert(sourceTask, at: 0)
            let destinationSnapShot = generateSnapshot(taskItems: items)
            dataSource.apply(destinationSnapShot, to: destinationSection)
            
            return
        }
        
        if sourceIndexPath.section == destinationIndexPath.section { //같은 section 일때
            let tasksAfterRemove = removeTaskFromTasks(dataSource.snapshot(for: sourceSection).rootItems, sourceTask.id)
            var newItems: [TaskVM]
            if destinationTask.parentPosition == nil && childCheck == 1 { //부모 작업의 바로 아래에 append
                newItems = addTaskAtFirstOfSubitems(tasksAfterRemove, sourceTask, destinationTask.id)
            } else { //child check필요 없이 그냥 넣기
                newItems = addTaskAtTasks(tasksAfterRemove, sourceTask, destinationTask.id)
            }
            let snapShot = generateSnapshot(taskItems: newItems)
            dataSource.apply(snapShot, to: sourceSection)
            //TODO parentsPoint 바꿔주기, 새로 서브 들어가는곳은 DISCLOSURE추가
        } else { //다른 section 일때
            let tasksAfterRemove = removeTaskFromTasks(dataSource.snapshot(for: sourceSection).rootItems, sourceTask.id)
            var newItems: [TaskVM]
            if destinationTask.parentPosition == nil && childCheck == 1 { //부모 작업의 바로 아래에 append
                newItems = addTaskAtFirstOfSubitems(dataSource.snapshot(for: destinationSection).rootItems, sourceTask, destinationTask.id)
            } else { //child check필요 없이 그냥 넣기
                newItems = addTaskAtTasks(dataSource.snapshot(for: destinationSection).rootItems, sourceTask, destinationTask.id)
            }
            let sourceSnapShot = generateSnapshot(taskItems: tasksAfterRemove)
            let destinationSnapShot = generateSnapshot(taskItems: newItems)
            dataSource.apply(sourceSnapShot, to: sourceSection)
            dataSource.apply(destinationSnapShot, to: destinationSection)
        }
    }
}


private extension TaskListViewController {
    
    func setLocation(_ location: CGPoint, _ destination: IndexPath?) -> Bool {
        lineView.removeFromSuperview()
        guard let destination = destination,
              let startIndex = startIndex,
              let startPoint = startPoint,
              let collectionView = taskListCollectionView
        else {
            return false
        }
        if destination.row == 0 { return true }
        
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
        guard let startCell = collectionView.cellForItem(at: startIndex) as? TaskCollectionViewListCell,
              let destinationCell = collectionView.cellForItem(at: tempIndex) as? TaskCollectionViewListCell,
              let cellCount = startCell.taskViewModel
        else {
            return false
        }
        if destinationCell.indentationLevel == 1 {
            childCheck = 0
            if cellCount.subItems.count != 0 {
                return false
            }
        } else if destinationCell.indentationLevel == 0 && childCheck == 1 && cellCount.subItems.count != 0 {
            return false
        }
        let depthWidth: CGFloat = CGFloat(destinationCell.indentationLevel * 20 + childCheck * 20)
        lineView = UIView(frame: CGRect(x: 10 + depthWidth, y: destinationCell.frame.height - 2, width: destinationCell.frame.width - depthWidth - 20, height: 5))
        lineView.backgroundColor = .halgoraedoMint
        lineView.layer.cornerRadius = 2;
        lineView.layer.masksToBounds = true;
        destinationCell.addSubview(lineView)
        return true
    }
}

// MARK: - TaskAddViewController Delegate

extension TaskListViewController: TaskAddViewControllerDelegate {
    
    func taskAddViewControllerDidDone(_ taskAddViewController: TaskAddViewController) {
        let taskFields = TaskListModels.TaskFields(title: taskAddViewController.text,
                                                   date: taskAddViewController.date,
                                                   priority: taskAddViewController.priority)
        interactor?.createTask(request: .init(taskFields: taskFields))
    }
}
