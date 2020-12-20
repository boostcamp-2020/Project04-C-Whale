//l
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
            var snapshot: NSDiffableDataSourceSectionSnapshot<TaskListModels.TaskVM>
            var sectionVM: TaskListModels.SectionVM
            var sectionVMs: [TaskListModels.SectionVM]
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
        struct RequestForList {
            var projectId: String
            var sourceIndexPath: IndexPath
            var destinationIndexPath: IndexPath
            var childCheck: Int
            var dataSource: UICollectionViewDiffableDataSource<TaskListModels.SectionVM, TaskVM>
            var destinationCell: TaskCollectionViewListCell?
        }
        
        struct RequestForBoard {
            var projectId: String
            var sectionViewModel: [TaskListModels.SectionVM]
            var sourceSection: TaskListModels.SectionVM
            var destinationSection: TaskListModels.SectionVM
            var sourceTask: TaskListModels.TaskVM
            var destinationTask: TaskListModels.TaskVM?
        }
        
        struct Response {
            var displayedTasks: [TaskVM]
            var sectionVMs: [TaskListModels.SectionVM]?
            var sourceSection: TaskListModels.SectionVM?
            var sectionIndex: Int?
            init(displayedTasks: [TaskVM],
                 sectionVMs: [TaskListModels.SectionVM]? = nil,
                 sourceSection: TaskListModels.SectionVM? = nil,
                 sectionIndex: Int? = nil) {
                self.displayedTasks = displayedTasks
                self.sectionVMs = sectionVMs
                self.sourceSection = sourceSection
                self.sectionIndex = sectionIndex
            }
        }
        
        struct ViewModel {
            var snapshot: NSDiffableDataSourceSectionSnapshot<TaskListModels.TaskVM>?
            var sectionVM: TaskListModels.SectionVM?
            var sectionVMs: [TaskListModels.SectionVM]?
            var sectionIndex: Int?
            var tasks: [TaskVM]?
            init(snapshot: NSDiffableDataSourceSectionSnapshot<TaskListModels.TaskVM>? = nil,
                 sectionVM: TaskListModels.SectionVM? = nil,
                 sectionVMs: [TaskListModels.SectionVM]? = nil,
                 sectionIndex: Int? = nil,
                 tasks: [TaskVM]? = nil) {
                self.snapshot = snapshot
                self.sectionVM = sectionVM
                self.sectionVMs = sectionVMs
                self.sectionIndex = sectionIndex
                self.tasks = tasks
            }
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
