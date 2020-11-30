//
//  TaskSectionViewCell.swift
//  HalgoraeDO
//
//  Created by 이상윤 on 2020/12/01.
//

import UIKit

class TaskSectionViewCell: UICollectionViewCell {
    
    typealias TaskVM = TaskListModels.DisplayedTask
    
    private var collectionView: UICollectionView?
    private var dataSource: UICollectionViewDiffableDataSource<String, TaskVM>! = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView = UICollectionView(frame: self.contentView.frame, collectionViewLayout: generateLayout())
        configureCollectionView()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(withImageName name: String) {
        guard let collectionView = collectionView else { return }
        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
        
        //  let snapShot = snapshot(taskItems: tasks)
        let snapShot = snapshot(taskItems: [])
        dataSource.apply(snapShot, to: "할고래", animatingDifferences: true)
        //dataSource.apply(snapShot)
      //  dataSource.apply(snapShot, animatingDifferences: false)
        
    }
}


// MARK: - Configure CollectionView Layout

private extension TaskSectionViewCell {
    
    private func configureCollectionView() {
        //        collectionView.dragDelegate = self
        //        collectionView.dropDelegate = self
        collectionView!.dragInteractionEnabled = true
        collectionView!.backgroundColor = .clear
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
            supplementaryView.configureHeader(sectionName: "할고래두 TODO List", rowNum: 10)
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
      //  snapshot.appendSections(["1123"])
        // TODO: 뷰 테스트를 위한 Task배열을 바로 만들어 넣어주는데 이 배열을 taskItems로 변경하기
      //  snapshot.appendItems([Task(section: "123", title: "1asdfasdfasdfsadfwerfweatfasdfv23", isCompleted: false, depth: 0, parent: nil, subTasks: []),Task(section: "123", title: "123", isCompleted: false, depth: 0, parent: nil, subTasks: []),Task(section: "123", title: "123", isCompleted: false, depth: 0, parent: nil, subTasks: []),Task(section: "123", title: "123", isCompleted: false, depth: 0, parent: nil, subTasks: []),Task(section: "123", title: "123", isCompleted: false, depth: 0, parent: nil, subTasks: []),Task(section: "123", title: "123", isCompleted: false, depth: 0, parent: nil, subTasks: []),Task(section: "123", title: "123", isCompleted: false, depth: 0, parent: nil, subTasks: []),Task(section: "123", title: "123", isCompleted: false, depth: 0, parent: nil, subTasks: []),Task(section: "123", title: "123", isCompleted: false, depth: 0, parent: nil, subTasks: []),Task(section: "123", title: "123", isCompleted: false, depth: 0, parent: nil, subTasks: []),Task(section: "123", title: "123", isCompleted: false, depth: 0, parent: nil, subTasks: []),Task(section: "123", title: "123", isCompleted: false, depth: 0, parent: nil, subTasks: []),Task(section: "123", title: "123", isCompleted: false, depth: 0, parent: nil, subTasks: []),Task(section: "123", title: "123", isCompleted: false, depth: 0, parent: nil, subTasks: []),Task(section: "123", title: "123", isCompleted: false, depth: 0, parent: nil, subTasks: []),Task(section: "123", title: "123", isCompleted: false, depth: 0, parent: nil, subTasks: []),Task(section: "123", title: "123", isCompleted: false, depth: 0, parent: nil, subTasks: []),Task(section: "123", title: "123", isCompleted: false, depth: 0, parent: nil, subTasks: []),Task(section: "123", title: "123", isCompleted: false, depth: 0, parent: nil, subTasks: []),Task(section: "123", title: "123", isCompleted: false, depth: 0, parent: nil, subTasks: [])], toSection: "1123")
        return snapshot
    }
}

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
        print("작업 추가 TODO")
        print("footer!!!!!=====", section)
    }
    
}
