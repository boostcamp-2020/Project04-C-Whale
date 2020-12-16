//
//  TaskListManager.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/30.
//

import Foundation

class TaskList {
    
    var sections: [Section] = []
    
    func task(taskVM: TaskListModels.TaskVM, indexPath: IndexPath) -> Task? {
        guard 0..<sections.count ~= indexPath.section else { return nil }
        
        return findTask(id: taskVM.id, in: sections[indexPath.section])
    }
    
    func task(taskVM: TaskListModels.TaskVM) -> Task? {
        for section in sections {
            guard let task = findTask(id: taskVM.id, in: section) else { continue }
            return task
        }
        
        return nil
    }
    
    func tasks(taskVMs: [TaskListModels.TaskVM]) -> [Task] {
        var tasks = [Task]()
        for section in sections {
            let ids = taskVMs.map { $0.id }
            tasks.append(contentsOf: findTasks(idList: ids, in: section))
        }
        
        return tasks
    }
    
    func findTask(id: String, in section: Section) -> Task? {
        let superTasks = section.tasks?.array as? [Task]
        
        guard let parentTasks = superTasks else { return nil }
        for task in parentTasks {
            if task.id == id {
                return task
            }
            guard let subTasks = task.tasks?.array as? [Task] else { continue }
            for subTask in subTasks where subTask.id == id {
                return subTask
            }
        }
        
        return nil
    }
    
    func findTasks(idList: [String], in section: Section) -> [Task] {
        var tasks = [Task]()
        for id in idList {
            guard let task = findTask(id: id, in: section) else { continue }
            tasks.append(task)
        }
        
        return tasks
    }
}
