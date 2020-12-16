//
//  TaskSectionViewCell.swift
//  HalgoraeDO
//
//  Created by 이상윤 on 2020/12/01.
//

import UIKit

protocol TaskSectionViewCellDelegate {
    func taskSectionViewCell(_ taskSectionViewCell: TaskSectionViewCell,
                             _ sourceSection: TaskListModels.SectionVM,
                       _ destinationSection: TaskListModels.SectionVM,
                       _ sourceTaskIdentifier: TaskListModels.TaskVM,
                       _ destinationTaskIdentifier: TaskListModels.TaskVM?)
    
    func taskSectionViewCell(_ taskSectionViewCell: TaskSectionViewCell,
                             didSelectedTask task: TaskListModels.TaskVM,
                             at section: Int)
    
    func taskSectionViewCellDidPullToRefresh(_ taskSectionViewCell: TaskSectionViewCell)
}

class TaskSectionViewCell: UICollectionViewCell {
    
    typealias TaskVM = TaskListModels.TaskVM
    
    // MARK: - Properties
    
    var taskSectionViewCellDelegate: TaskSectionViewCellDelegate?
    private var sectionNum: Int = -1
    private var startIndex: IndexPath?
    private var startPoint: CGPoint?
    private var collectionView: UICollectionView?
    private var dataSource: UICollectionViewDiffableDataSource<TaskListModels.SectionVM, TaskVM>! = nil
    private var sectionName: String = ""
    private var taskVM: [TaskVM] = []
    private var section: TaskListModels.SectionVM?
    private var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .halgoraedoMint
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        
        return view
    }()
    var tapHandler: ((TaskVM) -> Void)?
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .halgoraedoMint
        refreshControl.addTarget(self, action: #selector(didChangeRefersh(_:)), for: .valueChanged)
        
        return refreshControl
    }()
    
    // MARK: - View Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureForReuse()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configureForReuse()
    }
    
    // MARK: - Initialize
    
    func configureForReuse() {
        taskVM = []
        collectionView?.removeFromSuperview()
        configureCollectionView()
        configureDataSource()
        collectionView?.refreshControl = refreshControl
    }
    
    func configure(section: TaskListModels.SectionVM, sectionNum: Int) {
        #warning("코드 개선 필요!! 노션작성을 위해 section을 임시 생성")
        self.section = section
        taskVM = section.tasks
        self.sectionNum = sectionNum
        sectionName = section.title
        let snapShot = snapshot(taskItems: section.tasks)
        dataSource.apply(snapShot, to: section, animatingDifferences: true)
    }
    
    func reloadSnapshot(taskItems: [TaskVM]) {
        var snapshot = NSDiffableDataSourceSectionSnapshot<TaskVM>()
        snapshot.append(taskItems)
        guard let section = section else {
            return
        }
        dataSource.apply(snapshot, to: section, animatingDifferences: true)
    }
    
    @objc func didChangeRefersh(_ sender: UIRefreshControl) {
        taskSectionViewCellDelegate?.taskSectionViewCellDidPullToRefresh(self)
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: - Configure CollectionView Layout

private extension TaskSectionViewCell {
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: contentView.frame, collectionViewLayout: generateLayout())
        guard let collectionView = collectionView else { return }
        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
        collectionView.backgroundColor = .clear
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.delegate = self
        collectionView.dragInteractionEnabled = true
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50)), subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
        section.boundarySupplementaryItems = generateSupplementaryItems()
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func generateSupplementaryItems() -> [NSCollectionLayoutBoundarySupplementaryItem] {
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(44)),
                                                elementKind: "section-header-element-kind",
                                                alignment: .top)
        sectionHeader.pinToVisibleBounds = true
        sectionHeader.zIndex = 2
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(44)),
                                                elementKind: "section-footer-element-kind",
                                                alignment: .bottom)
        sectionFooter.pinToVisibleBounds = true
        sectionFooter.zIndex = 2
        
        return [sectionHeader, sectionFooter]
    }
}

// MARK: - Configure CollectionView Data Source

private extension TaskSectionViewCell {
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TaskCollectionViewListCell, TaskVM> { [weak self] (cell, _: IndexPath, taskItem) in
            cell.taskViewModel = taskItem
            cell.finishHandler = { [weak self] task in
                guard let self = self else { return }
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
            cell.backgroundConfiguration = background
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 1)
            cell.layer.shadowRadius = 5.0
            cell.layer.shadowOpacity = 0.2
            cell.layer.masksToBounds = false
        }
        guard let collectionView = collectionView else { return }
        dataSource = UICollectionViewDiffableDataSource<TaskListModels.SectionVM, TaskVM>(collectionView: collectionView, cellProvider: { (collectionview, indexPath, task) -> UICollectionViewCell? in
            return collectionview.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: task)
        })
        configureDataSource(dataSource)
    }
    
    func configureDataSource(_ dataSource: UICollectionViewDiffableDataSource<TaskListModels.SectionVM, TaskVM>) {
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <TaskBoardSupplementaryView>(elementKind: "Header") {
            (supplementaryView, string, indexPath) in
            supplementaryView.configureHeader(sectionName: self.sectionName, rowNum: self.taskVM.count)
        }
        let footerRegistration = UICollectionView.SupplementaryRegistration
        <TaskBoardSupplementaryView>(elementKind: "Footer") {
            (supplementaryView, string, indexPath) in
            supplementaryView.section = self.sectionNum
            supplementaryView.configureFooter()
        }
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView!.dequeueConfiguredReusableSupplementary(
                using: kind == "section-header-element-kind" ? headerRegistration : footerRegistration, for: index)
        }
    }
    
    func snapshot(taskItems: [TaskVM]) -> NSDiffableDataSourceSectionSnapshot<TaskVM> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<TaskVM>()
        snapshot.append(taskItems)
        return snapshot
    }
}

// MARK: - UICollectionView Delegate

extension TaskSectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let task = dataSource.itemIdentifier(for: indexPath) else { return }
        
        taskSectionViewCellDelegate?.taskSectionViewCell(self, didSelectedTask: task, at: sectionNum)
    }
}

// MARK: - UICollectionViewDragDelegate

extension TaskSectionViewCell: UICollectionViewDragDelegate {
    
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
        guard let collectionView = collectionView,
            let taskObject = collectionView.cellForItem(at: indexPath) as? TaskCollectionViewListCell else { return [] }
        let provider = NSItemProvider(object: taskObject.taskViewModel!.id as NSString)
        let dragItem = UIDragItem(itemProvider: provider)
        let cell = collectionView.cellForItem(at: indexPath)
        dragItem.localObject = [cell, dataSource]
        
        return [dragItem]
    }
}

// MARK: - UICollectionViewDropDelegate
extension TaskSectionViewCell: UICollectionViewDropDelegate {
    
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
        startIndex = nil
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        performDropWith coordinator: UICollectionViewDropCoordinator
    ) {
        lineView.removeFromSuperview()
        
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            guard let sourceTask = ((item.dragItem.localObject as? [Any])?.first as? TaskCollectionViewListCell)?.taskViewModel else { return }
            if let sourceIndexPath = item.sourceIndexPath {//자신으로부터 나왔을 때
                var tempDestinationIndex: IndexPath
                if destinationIndexPath.section == sourceIndexPath.section && destinationIndexPath.row > sourceIndexPath.row {
                    tempDestinationIndex = IndexPath(row: destinationIndexPath.row, section: destinationIndexPath.section)
                } else {
                    tempDestinationIndex = IndexPath(row: destinationIndexPath.row - 1, section: destinationIndexPath.section)
                }
                let sourceSection = dataSource.snapshot().sectionIdentifiers[tempDestinationIndex.section]
                
                if tempDestinationIndex.row == -1 {
                    taskSectionViewCellDelegate?.taskSectionViewCell(self, sourceSection, sourceSection, sourceTask, nil)
                } else {
                    taskSectionViewCellDelegate?.taskSectionViewCell(self, sourceSection, sourceSection, sourceTask, sourceSection.tasks[tempDestinationIndex.row])
                }
                
            } else {
                let destinationIndexPath = IndexPath(row: destinationIndexPath.row - 1, section: destinationIndexPath.section)
                let collLocalDragSession = coordinator.session.localDragSession?.localContext as? UICollectionView
                let sourceDataSource = collLocalDragSession?.dataSource as? UICollectionViewDiffableDataSource<TaskListModels.SectionVM, TaskVM>
                let destinationSection = dataSource.snapshot().sectionIdentifiers[destinationIndexPath.section]
                
                if destinationIndexPath.row == -1 {
                    taskSectionViewCellDelegate?.taskSectionViewCell(self, (sourceDataSource?.snapshot().sectionIdentifier(containingItem: sourceTask))!, destinationSection, sourceTask, nil)
                } else {
                    taskSectionViewCellDelegate?.taskSectionViewCell(self, (sourceDataSource?.snapshot().sectionIdentifier(containingItem: sourceTask))!, destinationSection, sourceTask, destinationSection.tasks[destinationIndexPath.row])
                }
            }
        }
    }
}

private extension TaskSectionViewCell {
    
    func setLocation(_ location: CGPoint, _ destination: IndexPath) {
        lineView.removeFromSuperview()
        guard let collectionView = collectionView else { return }

        var tempDestinationIndex: IndexPath = destination
        if let startIndex = startIndex {
            if destination.section == startIndex.section && destination.row > startIndex.row {
                tempDestinationIndex = IndexPath(row: destination.row, section: destination.section)
            } else {
                tempDestinationIndex = IndexPath(row: destination.row - 1, section: destination.section)
            }
        } else {
            tempDestinationIndex = IndexPath(row: destination.row - 1, section: destination.section)
        }
        
        if let cell = collectionView.cellForItem(at: tempDestinationIndex) as? UICollectionViewListCell {
            lineView.frame = CGRect(x: 10, y: cell.frame.height - 2, width: cell.frame.width - 20, height: 5)
            cell.addSubview(lineView)
        }
    }
}
