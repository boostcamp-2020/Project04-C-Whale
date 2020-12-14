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
        
        var superTasks = sections[indexPath.section].tasks?.array as? [Task]
        if let parentPosition = taskVM.parentPosition,
           0..<(superTasks?.count ?? 0) ~= parentPosition {
            superTasks = superTasks?[parentPosition].tasks?.array as? [Task]
        }
        
        return superTasks?[taskVM.position]
    }
    
    func task(identifier: String, postion: Int, parentPosition: Int?) -> Task? {
        
        var superTasks = tasks
        if let parentPosition = parentPosition  {
            superTasks = tasks[parentPosition].tasks?.array as? [Task] ?? []
        }
        let isInRagne = 0..<superTasks.count ~= postion
        
        return isInRagne ? superTasks[postion] : nil
    }
}
