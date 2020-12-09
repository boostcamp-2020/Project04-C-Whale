//
//  TaskListModels.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import UIKit

enum TaskListModels {
    
    // MARK:  - Usecases
    
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
            var displayedTasks: [DisplayedTask]
        }
        
        struct Response {
            var tasks: [Task]
        }
        
        struct ViewModel {
            var displayedTasks: [DisplayedTask]
        }
    }
    
    enum ReorderTask {
        struct Request {
            var displayedTask: DisplayedTask
        }
        
        struct Response {
            var task: Task
        }
        
        struct ViewModel {
            var displayedTask: DisplayedTask
        }
    }
    
    enum CreateTask {
        struct Request {
            var taskFields: TaskFields
        }
        
        struct Response {
            var task: Task
        }
        
        struct ViewModel {
            var displayedTask: DisplayedTask
        }
    }
    
    // MARK:  - Models
    
    struct TaskFields {
        var title: String
        var date: Date?
        var priority: Priority
    }
    
    struct SectionVM {
        var id: String
        var title: String
        var tasks: [DisplayedTask] = []
        
        init(id: String,
            title: String,
            tasks: [DisplayedTask]) {
            self.id = id
            self.title = title
            self.tasks = tasks
        }
        
        init(section: Section) {
            self.id = section.id
            self.title = section.title
            self.tasks = section.tasks?.compactMap { DisplayedTask(task: $0) } ?? []
        }
    }
    
    struct DisplayedTask: TaskContentViewModelType {
        var id: String
        var title: String
        var isCompleted: Bool
        var tintColor: UIColor
        var position: Int
        var parentPosition: Int?
        var subItems: [DisplayedTask] = []
        
        init(id: String,
             title: String,
             isCompleted: Bool = false,
             tintColor: UIColor,
             position: Int,
             parentPosition: Int?,
             subItems: [DisplayedTask]) {
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
            self.title = task.title
            self.isCompleted = task.isDone
            self.tintColor = task.priority?.color ?? .black
            self.position = task.position
            self.parentPosition = task.parent?.position
            guard let tasks = task.tasks else { return }
            self.subItems = tasks.compactMap { DisplayedTask(task: $0) }
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


extension TaskListModels.DisplayedTask: Hashable {
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
