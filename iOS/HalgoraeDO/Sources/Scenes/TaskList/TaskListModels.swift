//
//  TaskListModels.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import UIKit

enum TaskListModels {
    
    // MARK:  - Use cases
    
    enum FetchTasks {
        struct Request {
            var showCompleted: Bool
        }
        
        struct Response {
            var tasks: [Task]
        }
        
        struct ViewModel {
            var displayedTasks: [DisplayedTask]
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
}

// MARK:  - Models

extension TaskListModels {
    
    struct TaskFields {
        
    }
    
    struct DisplayedTask: Hashable {
        var id: UUID
        var title: String
        var isCompleted: Bool
        var tintColor: UIColor
        var position: Int
        var parentPosition: Int?
        var subItems: [DisplayedTask]
        
        init(id: UUID,
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
        
        init(task: Task, position: Int, parentPosition: Int?) {
            self.id = task.identifier
            self.title = task.title
            self.isCompleted = task.isCompleted
            self.tintColor = task.priority.color
            self.position = position
            self.parentPosition = parentPosition
            self.subItems = task.subTasks.enumerated().compactMap { (idx, task) in
                DisplayedTask(task: task, position: idx, parentPosition: position)
            }
        }
        
        static func ==(lhs: Self, rhs: Self) -> Bool {
            return lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
}
