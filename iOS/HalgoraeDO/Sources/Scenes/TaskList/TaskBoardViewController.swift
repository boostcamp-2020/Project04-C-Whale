//
//  TaskBoardViewController.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import UIKit

enum Section: Int, Hashable, CaseIterable, CustomStringConvertible {
    case list1, list2, list3
    
    var description: String {
        switch self {
        case .list1: return "List1"
        case .list2: return "List2"
        case .list3: return "List3"
        }
    }
}

class TaskBoardViewController: UIViewController {

    // MARK: - Properties
    
    private var interactor: TaskListBusinessLogic?
    private var router: (TaskListRoutingLogic & TaskListDataPassing)?
    private var dataSource: UICollectionViewDiffableDataSource<String, Task>! = nil
    private var lineView: UIView = UIView()
    private var startIndex: IndexPath?
    private var startPoint: CGPoint?
    
    // MARK: - Views
    
    @IBOutlet weak private var taskBoardCollectionView: UICollectionView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLogic()
        configureCollectionView()
        configureDataSource()
        taskBoardCollectionView.dragDelegate = self
        taskBoardCollectionView.dropDelegate = self
        taskBoardCollectionView.dragInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.fetchTasks()
    }
    
    // MARK: - Initialize
    
    private func configureLogic() {
        let presenter = TaskListPresenter(viewController: self)
        let interactor = TaskListInteractor(presenter: presenter, worker: TaskListWorker())
        
        self.interactor = interactor
    }
}

// MARK: - TaskList Display Logic

extension TaskBoardViewController: TaskListDisplayLogic {
    func display(tasks: [Task]) {
        let snapShot = snapshot(taskItems: tasks)
        let snapShot1 = snapshot(taskItems: tasks)
        let snapShot2 = snapshot(taskItems: tasks)
        dataSource.apply(snapShot, to: "list1", animatingDifferences: true)
        dataSource.apply(snapShot1, to: "list2", animatingDifferences: true)
    }
}

// MARK: - Configure CollectionView Layout

private extension TaskBoardViewController {
    private func configureCollectionView() {
        taskBoardCollectionView.collectionViewLayout = generateLayout()
        taskBoardCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func generateLayout() -> UICollectionViewLayout {
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        config.scrollDirection = .horizontal
        
        //==== TODO
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let section: NSCollectionLayoutSection
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(100))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 15
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        
    }
}

// MARK: - Configure CollectionView Data Source

private extension TaskBoardViewController {

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TaskCollectionViewListCell, Task> { [weak self] (cell, indexPath, taskItem) in
            
            cell.task = taskItem
            cell.completeHandler = { [weak self] task in
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
            
            //==== TODO
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 5)
            cell.layer.shadowRadius = 7.0
            cell.layer.shadowOpacity = 0.2
            cell.layer.masksToBounds = false
    
            var background = UIBackgroundConfiguration.listPlainCell()
            background.cornerRadius = 8
            background.strokeColor = .systemGray3
            cell.backgroundConfiguration = background
        }
        
        //TODO cellProvider 안써도 될듯
        self.dataSource = UICollectionViewDiffableDataSource<String, Task>(collectionView: taskBoardCollectionView, cellProvider: { (collectionview, indexPath, task) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            return collectionview.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: task)
        })
        
    }
    
    private func snapshot(taskItems: [Task]) -> NSDiffableDataSourceSectionSnapshot<Task> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<Task>()

        func addItems(_ taskItems: [Task], to parent: Task?) {
            
            snapshot.append(taskItems, to: parent)
        }
        addItems(taskItems, to: nil)
    
        snapshot.append([Task(section: "123", title: "123", isCompleted: false, depth: 0, parent: nil, subTasks: [])], to: nil)
        snapshot.append([Task(section: "123", title: "123", isCompleted: false, depth: 0, parent: nil, subTasks: [])], to: nil)
        snapshot.append([Task(section: "1233", title: "1233", isCompleted: false, depth: 1, parent: nil, subTasks: [])], to: nil)
        snapshot.append([Task(section: "1233", title: "12334", isCompleted: false, depth: 0, parent: nil, subTasks: [])], to: nil)
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
        let taskObject = NSString(string: "123123")
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
    
    /* performDropWith로 들어가지 못하고 cancle되었을 때 lineView를 제거 */
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        lineView.removeFromSuperview()
    }
    
    /* performDropWith이 수행될 때 lineView를 제거 */
    func collectionView(
        _ collectionView: UICollectionView,
        performDropWith coordinator: UICollectionViewDropCoordinator
    ) {
        lineView.removeFromSuperview()
        print("destination path:", coordinator.destinationIndexPath)
    }
    
}


extension TaskBoardViewController {
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



