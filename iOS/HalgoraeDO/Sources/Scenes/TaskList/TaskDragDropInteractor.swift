//
//  TaskDragDropInteractor.swift
//  HalgoraeDO
//
//  Created by 이상윤 on 2020/12/16.
//

import UIKit

class TaskDragDropInteractor {
    
    // MARK:  - Constants
    
    typealias TaskVM = TaskListModels.TaskVM
    
    var presenter: TaskListPresentLogic
    
    init(presenter: TaskListPresentLogic) {
        self.presenter = presenter
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
    
    func dropHelper(projectId: String, childCheck: Int, sourceIndexPath: IndexPath, destinationIndexPath: IndexPath,
                    dataSource: UICollectionViewDiffableDataSource<TaskListModels.SectionVM, TaskVM>, destinationCell: TaskCollectionViewListCell?) -> TaskListModels.MoveTask.Request? {
        guard let sourceTask = dataSource.itemIdentifier(for: sourceIndexPath)
        else {
            return nil
        }
        
        let sourceSection = dataSource.snapshot().sectionIdentifiers[sourceIndexPath.section]
        let destinationSection = dataSource.snapshot().sectionIdentifiers[destinationIndexPath.section]
        let tasksAfterRemove = removeTaskFromTasks(dataSource.snapshot(for: sourceSection).rootItems, sourceTask.id)
        
        guard let destinationTask = dataSource.itemIdentifier(for: destinationIndexPath)
        else {//섹션 상단에 추가시
            presenter.presentFinishDragDrop(viewModel: .init(displayedTasks: tasksAfterRemove, sourceSection: sourceSection))
            var newItems = dataSource.snapshot(for: destinationSection).rootItems
            newItems.insert(sourceTask, at: 0)
            let destinationSnapShot = generateSnapshot(taskItems: newItems)
            dataSource.apply(destinationSnapShot, to: destinationSection)
            presenter.presentFinishDragDrop(viewModel: .init(displayedTasks: newItems, sourceSection: destinationSection))
            return dragDropApiHelper(projectId: projectId, sectionId: destinationSection.id, sourceTask: sourceTask, sendTasks: dataSource.snapshot(for: destinationSection).rootItems)
        }
        var newItems: [TaskVM]
        var tempItem = sourceTask
        tempItem.parentPosition = destinationTask.parentPosition
        if sourceIndexPath.section == destinationIndexPath.section { //같은 section 일때
            if destinationTask.parentPosition == nil && childCheck == 1 { //부모 작업의 바로 아래에 append
                newItems = addTaskAtFirstOfSubitems(tasksAfterRemove, sourceTask, destinationTask, destinationIndexPath, destinationCell)
            } else { //child check필요 없이 그냥 넣기
                newItems = addTaskAtTasks(tasksAfterRemove, tempItem, destinationTask.id)
            }
            presenter.presentFinishDragDrop(viewModel: .init(displayedTasks: newItems, sourceSection: sourceSection))
        } else { //다른 section 일때
            if destinationTask.parentPosition == nil && childCheck == 1 { //부모 작업의 바로 아래에 append
                newItems = addTaskAtFirstOfSubitems(dataSource.snapshot(for: destinationSection).rootItems, sourceTask, destinationTask, destinationIndexPath, destinationCell)
            } else { //child check필요 없이 그냥 넣기
                newItems = addTaskAtTasks(dataSource.snapshot(for: destinationSection).rootItems, tempItem, destinationTask.id)
            }
            presenter.presentFinishDragDrop(viewModel: .init(displayedTasks: tasksAfterRemove, sourceSection: sourceSection))
            presenter.presentFinishDragDrop(viewModel: .init(displayedTasks: newItems, sourceSection: destinationSection))
        }
        return dragDropApiHelper(projectId: projectId, sectionId: destinationSection.id, sourceTask: sourceTask, allTasks: dataSource.snapshot(for: destinationSection).rootItems)
    }
    
    private func dragDropApiHelper(projectId: String, sectionId: String, sourceTask: TaskVM, sendTasks: [TaskVM]) -> TaskListModels.MoveTask.Request {//섹션 상단 (하위 X)
        var taskIds: [String] = []
        for task in sendTasks {
            taskIds.append(task.id)
        }
        return .init(projectId: projectId, sectionId: sectionId, taskId: sourceTask.id, parentTaskId: nil, taskMoveSection: .init(sectionId: sectionId), taskMoveFields: .init(orderedTasks: taskIds))//섹션간 이동 함수 사용
    }
    
    private func dragDropApiHelper(projectId: String, sectionId: String, sourceTask: TaskVM, allTasks: [TaskVM]) -> TaskListModels.MoveTask.Request? {
        for rootTask in allTasks {
            if rootTask.id == sourceTask.id {
                var taskIds: [String] = []
                for task in allTasks {
                    taskIds.append(task.id)
                }
                return .init(projectId: projectId, sectionId: sectionId, taskId: sourceTask.id, parentTaskId: nil, taskMoveSection: .init(sectionId: sectionId), taskMoveFields: .init(orderedTasks: taskIds)) //섹션간 이동
            }
            for subTask in rootTask.subItems where subTask.id == sourceTask.id {
                var taskIds: [String] = []
                for task in rootTask.subItems {
                    taskIds.append(task.id)
                }
                return .init(projectId: nil, sectionId: sectionId, taskId: sourceTask.id, parentTaskId: rootTask.id, taskMoveSection: .init(sectionId: sectionId), taskMoveFields: .init(orderedTasks: taskIds)) //테스크 하위로
            }
        }
        return nil
    }
}

extension TaskDragDropInteractor {
    
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
    
    private func addTaskAtTasks(_ taskItems: [TaskVM], _ sourceTask: TaskVM, _ destinationId: String) -> [TaskVM] {
        var tempItems: [TaskVM] = []
        for i in 0..<taskItems.count {
            tempItems.append(taskItems[i])
            if !taskItems[i].subItems.isEmpty {
                tempItems[i].subItems = addTaskAtTasks(taskItems[i].subItems, sourceTask, destinationId)
            }
            if taskItems[i].id == destinationId {
                var tempItem = taskItems
                tempItem.insert(sourceTask, at: i + 1)
                return tempItem
            }
        }
        
        return tempItems
    }
    
    private func addTaskAtFirstOfSubitems(_ taskItems: [TaskVM], _ sourceTask: TaskVM, _ destinationTask: TaskVM, _ destinationIndexPath: IndexPath, _ destinationCell: TaskCollectionViewListCell?) -> [TaskVM] {
        var tempItems: [TaskVM] = taskItems
        for i in 0..<tempItems.count {
            if tempItems[i].id == destinationTask.id {
                tempItems[i].subItems.insert(sourceTask, at: 0)
            }
        }
        let disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .automatic)
        destinationCell?.taskViewModel?.subItems.insert(destinationTask, at: 0)
        destinationCell?.accessories = [.outlineDisclosure(options: disclosureOptions)]
        
        return tempItems
    }
}
