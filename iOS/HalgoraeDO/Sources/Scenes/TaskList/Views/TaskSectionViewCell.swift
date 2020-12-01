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
        collectionView = UICollectionView(frame: self.contentView.frame, collectionViewLayout: generateLayout())
        configureCollectionView()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Configure
    
    func configure(sectionName: String, task: [TaskVM]) {
        taskVM = task
        self.sectionName = sectionName
        let snapShot = snapshot(taskItems: task)
        dataSource.apply(snapShot, to: sectionName, animatingDifferences: true)
    }
    
}


// MARK: - Configure CollectionView Layout

private extension TaskSectionViewCell {
    
    private func configureCollectionView() {
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
    
    private func generateLayout() -> UICollectionViewLayout {
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
        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
}

// MARK: - Configure CollectionView Data Source

private extension TaskSectionViewCell {
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TaskCollectionViewListCell, TaskVM> { [weak self] (cell, _: IndexPath, taskItem) in
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
            cell.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.layer.shadowRadius = 7.0
            cell.layer.shadowOpacity = 0.2
            cell.layer.masksToBounds = false
            cell.backgroundConfiguration = background
        }
        self.dataSource = UICollectionViewDiffableDataSource<String, TaskVM>(collectionView: collectionView!, cellProvider: { (collectionview, indexPath, task) -> UICollectionViewCell? in
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
            supplementaryView.section = indexPath.section
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

//TODO : 따로 파일로 분할하지 않고 우선 여기에 작성하였습니다. class 파일 분할이 필요합니다.
class TaskBoardSupplementaryView: UICollectionReusableView {
    
    var section: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let view = UIView()
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        self.layer.backgroundColor = UIColor.white.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureHeader(sectionName: String, rowNum: Int) {
        let sectionLabel = UILabel()
        let rowNumberLabel = UILabel()
        let moreButton = UIButton()
        let moreImage = UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .medium))
        
        addSubview(sectionLabel)
        addSubview(rowNumberLabel)
        addSubview(moreButton)
        moreButton.setImage(moreImage, for: .normal)
        moreButton.tintColor = .gray
        sectionLabel.text = sectionName
        sectionLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(20))
        rowNumberLabel.text = "\(rowNum)"
        
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        rowNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sectionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            sectionLabel.trailingAnchor.constraint(equalTo: rowNumberLabel.leadingAnchor, constant: 20),
            sectionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            rowNumberLabel.widthAnchor.constraint(equalToConstant: 50),
            rowNumberLabel.trailingAnchor.constraint(equalTo: moreButton.leadingAnchor, constant: 20),
            rowNumberLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            moreButton.widthAnchor.constraint(equalToConstant: 50),
            moreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            moreButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
        ])
    }
    
    func configureFooter() {
        let addTaskButton = UIButton()
        let plusImage = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .bold, scale: .medium))
        addSubview(addTaskButton)
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        addTaskButton.setImage(plusImage, for: .normal)
        addTaskButton.setTitleColor(.systemGray, for: .normal)
        addTaskButton.setTitle(" 작업 추가", for: .normal)
        addTaskButton.tintColor = .red
        addTaskButton.addTarget(self, action: #selector(priorityPopover), for: .touchUpInside)
        NSLayoutConstraint.activate([
            addTaskButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            addTaskButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            addTaskButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    @objc func priorityPopover(_ sender: UIButton) {
        #if DEBUG
        print("작업 추가 TODO")
        print("footer!!!!!=====", section)
        #endif
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
        print("destination path:", coordinator.destinationIndexPath)
    }
    
}

private extension TaskSectionViewCell {
    func setLocation(_ location: CGPoint, _ destination: IndexPath?) {
        #if DEBUG
        print("location:", location)
        print("start:", startPoint)
        #endif
        
        lineView.removeFromSuperview()
        guard let destination = destination,
              let startIndex = startIndex,
              let startPoint = startPoint,
              let collectionView = collectionView
        else{
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
        }else {
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

