//
//  TaskListModels.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import UIKit

enum TaskListModels {
    
    // MARK: - Usecases
    
    enum FetchTasks {
        struct Request {
            var projectId: String?
        }
        
        struct Response {
            var sections: [Section]
        }
        
        struct ViewModel {
            var sectionVMs: [SectionVM]
        }
    }
    
    enum FinishTask {
        struct Request {
            var displayedTasks: [TaskVM]
        }
        
        struct Response {
            var tasks: [Task]
        }
        
        struct ViewModel {
            var displayedTasks: [TaskVM]
        }
    }
    
    enum ReorderTask {
        struct Request {
            var taskId: String
            var displayedTask: TaskUpdateFields
        }
        
        struct Response {
            var task: Task
        }
        
        struct ViewModel {
            var displayedTask: TaskVM
        }
    }
    
    enum CreateTask {
        struct Request {
            var projectId: String
            var sectionId: String
            var taskFields: TaskFields
        }
        
        struct Response {
            var task: Task
        }
        
        struct ViewModel {
            var displayedTask: TaskVM
        }
    }
    
    enum UpdateTask {
        struct Request {
            var taskId: String
            var projectId: String
            var taskFileds: TaskUpdateFields
        }
    }
    
    enum CreateSection {
        struct Request {
            var projectId: String
            var sectionFields: SectionFields
        }
    }
    
    enum MoveTask {
        struct Request {
            var projectId: String?
            var sectionId: String
            var taskId: String
            var parentTaskId: String?
            var taskMoveSection: TaskMoveSection
            var taskMoveFields: TaskMoveFields
        }
    }
    
    enum DragDropTask {
        struct DragDropRequest {
            var projectId: String
            var sourceIndexPath: IndexPath
            var destinationIndexPath: IndexPath
            var childCheck: Int
            var dataSource: UICollectionViewDiffableDataSource<TaskListModels.SectionVM, TaskVM>
            var destinationCell: TaskCollectionViewListCell?
        }
        
        struct ViewModel {
            var displayedTasks: [TaskVM]
            var sourceSection: TaskListModels.SectionVM
        }
    }
    
    // MARK:  - Models
    
    struct SectionFields: Encodable {
        var title: String
    }
    
    struct TaskFields: Encodable {
        var title: String
        var date: Date?
        var priority: String
    }
    
    struct TaskUpdateFields: Encodable {
        var title: String
        var isDone: Bool
        var dueDate: String?
        var priority: String?
    }
    
    struct TaskMoveFields: Encodable {
        var orderedTasks: [String]
    }
    
    struct TaskMoveSection: Encodable {
        var sectionId: String
    }
    
    struct SectionVM {
        var id: String
        var title: String
        var tasks: [TaskVM] = []
        
        init(id: String,
            title: String,
            tasks: [TaskVM]) {
            self.id = id
            self.title = title
            self.tasks = tasks
        }
        
        init(section: Section) {
            self.id = section.id
            self.title = section.title ?? ""
            self.tasks = section.tasks?.compactMap({ $0 as? Task }).map { TaskVM(task: $0) } ?? []
        }
    }
    
    struct TaskVM: TaskContentViewModelType {
        var id: String
        var title: String
        var isCompleted: Bool
        var tintColor: UIColor
        var position: Int
        var parentPosition: Int?
        var subItems: [TaskVM] = []
        
        init(id: String,
             title: String,
             isCompleted: Bool = false,
             tintColor: UIColor,
             position: Int,
             parentPosition: Int?,
             sectionId: String,
             subItems: [TaskVM]) {
            self.id = id
            self.title = title
            self.isCompleted = isCompleted
            self.tintColor = tintColor
            self.position = position
            self.parentPosition = parentPosition
            self.subItems = subItems
        }
        
        init(task: Task) {
            self.id = task.id
            self.title = task.title ?? ""
            self.isCompleted = task.isDone
            self.tintColor = task.priority.color
            self.position = Int(task.position)
            if let parentPosition = task.parent?.position {
                self.parentPosition = Int(parentPosition)
            }
            guard let tasks = task.tasks, tasks.count != 0 else { return }
            let subTasks = tasks.array as? [Task] ?? []
            self.subItems = subTasks.map {
                TaskVM(task: $0)
            }
        }
    }
}

extension TaskListModels.SectionVM: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

extension TaskListModels.TaskVM: Hashable {
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
