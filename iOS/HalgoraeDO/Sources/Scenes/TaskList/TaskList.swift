//
//  TaskListManager.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/30.
//

import Foundation

class TaskList {
    
    var sections: [Section] = []
    var tasks: [Task] = []
    
    func task(taskVM: TaskListModels.DisplayedTask, indexPath: IndexPath) -> Task? {
        guard 0..<sections.count ~= indexPath.section else { return nil }
        let superTasks = sections[indexPath.section].tasks?.array as? [Task]
        
        guard let parentTasks = superTasks else { return nil }
        for task in parentTasks {
            if task.id == taskVM.id {
                return task
            }
            guard let subTasks = task.tasks?.array as? [Task] else { continue }
            for subTask in subTasks where subTask.id == taskVM.id {
                return subTask
            }
        }
        
        return nil
    }
    
    func task(identifier: String, postion: Int, parentPosition: Int?) -> Task? {
        #warning("TODO 함수 필요 확인 task 비어있는 배열이라 뭐하는거지??")
        var superTasks = tasks
        if let parentPosition = parentPosition  {
            superTasks = tasks[parentPosition].tasks?.array as? [Task] ?? []
        }
        let isInRagne = 0..<superTasks.count ~= postion
        
        return isInRagne ? superTasks[postion] : nil
    }
}
