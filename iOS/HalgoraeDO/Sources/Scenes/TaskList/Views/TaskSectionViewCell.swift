//
//  TaskSectionViewCell.swift
//  HalgoraeDO
//
//  Created by 이상윤 on 2020/12/01.
//

import UIKit

class TaskSectionViewCell: UICollectionViewCell {
    
    typealias TaskVM = TaskListModels.DisplayedTask
    
    // MARK: - Properties
    
    private var sectionNum: Int = -1
    private var lineView: UIView = UIView()
    private var startIndex: IndexPath?
    private var startPoint: CGPoint?
    private var collectionView: UICollectionView?
    private var dataSource: UICollectionViewDiffableDataSource<String, TaskVM>! = nil
    private var sectionName: String = ""
    private var taskVM: [TaskVM] = []
    
    // MARK: - View Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureForReuse()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        configureForReuse()
    }
    
    
    // MARK: - Initialize
    
    func configureForReuse() {
        dataSource = nil
        taskVM = []
        collectionView?.removeFromSuperview()
        configureCollectionView()
        configureDataSource()
    }
    
    func configure(sectionName: String, task: [TaskVM], sectionNum: Int) {
        taskVM = task
        self.sectionNum = sectionNum
        self.sectionName = sectionName
        let snapShot = snapshot(taskItems: task)
        dataSource.apply(snapShot, to: sectionName, animatingDifferences: true)
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
        collectionView.dragInteractionEnabled = true
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
        section.boundarySupplementaryItems = generateSupplementaryItems()
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func generateSupplementaryItems() -> [NSCollectionLayoutBoundarySupplementaryItem] {
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(44)),
            elementKind: "section-header-element-kind",
            alignment: .top)
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(44)),
            elementKind: "section-footer-element-kind",
            alignment: .bottom)
        sectionHeader.pinToVisibleBounds = true
        sectionHeader.zIndex = 2
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
        dataSource = UICollectionViewDiffableDataSource<String, TaskVM>(collectionView: collectionView!, cellProvider: { (collectionview, indexPath, task) -> UICollectionViewCell? in
            return collectionview.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: task)
        })
        
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

// MARK: - UICollectionViewDragDelegate

extension TaskSectionViewCell: UICollectionViewDragDelegate {
    
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
        let taskObject = NSString(string: "_")
        let provider = NSItemProvider(object: taskObject)
        let dragItem = UIDragItem(itemProvider: provider)
        guard let collectionView = collectionView else { return [dragItem] }
        let cell = collectionView.cellForItem(at: indexPath)
        dragItem.localObject = cell
        
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
        #if DEBUG
        print("destination path:", coordinator.destinationIndexPath ?? "Not found")
        #endif
    }
}

private extension TaskSectionViewCell {
    
    func setLocation(_ location: CGPoint, _ destination: IndexPath?) {
        #if DEBUG
        print("location:", location)
        print("start:", startPoint ?? "Not found")
        #endif
        
        lineView.removeFromSuperview()
        guard let destination = destination,
              let startIndex = startIndex,
              let _ = startPoint,
              let collectionView = collectionView
        else {
            return
        }
        if destination.row == 0 {
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
        if let cell = collectionView.cellForItem(at: tempIndex) as? UICollectionViewListCell {
            lineView = UIView(frame: CGRect(x: 10, y: cell.frame.height - 2, width: cell.frame.width - 20, height: 5))
            lineView.backgroundColor = .blue
            lineView.layer.cornerRadius = 5;
            lineView.layer.masksToBounds = true;
            cell.addSubview(lineView)
        }
    }
}

